library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity encrypt_engine is
	port (
		key : in cipherkey;
		clk : in std_logic;
		plaintext : in cipherblock;
		ciphertext : out cipherblock
	);
end encrypt_engine;


architecture structural of encrypt_engine is

type encrypt_state is (
	expand_key,
	add_round_key,
	sub_byte,
	shift_rows,
	mix_columns
);

signal curr_state, next_state : encrypt_state;

type cipherblocks is array(0 to NR+1) of cipherblock;
signal roundblocks : cipherblocks;

signal roundkeys : KeySchedule;

component round
	port (
		x : in cipherblock;
		y : out cipherblock;
		subkey : in cipherkey
	);
end component;

component key_adder
    port (
        x : in cipherblock;
        key : in cipherkey;
        z : out cipherblock
    );
end component;

component state_sbox
    port ( 
        x : in cipherblock;
        z : out cipherblock
    );
end component;

component row_shifter
   -- generic (ROWNUM : natural := 0);
    port (
        state : in cipherblock;
        shifted : out cipherblock
    );
end component;

signal lr_subbed, lr_shifted : cipherblock;

begin

	roundkeys <= keyexpansion(key, nk);
	roundblocks(0) <= plaintext;
	-- first round
    FIRST_ADDKEY : key_adder 
		port map (
			x => roundblocks(0),
			key => cipherkey(roundkeys(0 to 15)),
			z => roundblocks(1)
		);

	
	ROUND_GEN : for r in 1 to NR-1 generate
		RND : round 
			port map (
				x => roundblocks(r),
				subkey => cipherkey(roundkeys(r*16 to r*16 + 15)),
				y => roundblocks(r+1)
			);
	end generate ROUND_GEN;
    
	END_SHIFTROWS : row_shifter
		port map(state => roundblocks(NR), shifted => lr_shifted);
	END_SBOX : state_sbox 
		port map(x => lr_shifted, z => lr_subbed);
	END_ADDKEY : key_adder
		port map(
			x => lr_subbed,
			key => cipherkey(roundkeys(160 to 175)),
			z => roundblocks(NR+1)
		);

    ciphertext <= roundblocks(NR+1);
    
end structural;