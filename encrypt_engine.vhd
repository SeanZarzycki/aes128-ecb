library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity encrypt_engine is
	generic (KEY_LEN : natural := 128; BLOCK_SIZE : natural := 128);
	port (
		key : in std_logic_vector(KEY_LEN - 1 downto 0);
		plaintext : in std_logic_vector(TEXT_LEN - 1 downto 0)
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

signal state_matrix : std_logic_vector(BLOCK_SIZE - 1 downto 0);

component subbyte_reg is
	generic (BLOCK_SIZE : natural);
	port (
		state_matrix : in std_logic_vector(BLOCK_SIZE - 1 downto 0);
		subbyte_matrix : out std_logic_vector(BLOCK_SIZE - 1 downto 0)
	);

end component;

component row_shifter is
	generic (BLOCK_SIZE : natural);
	port (
		state_matrix : in std_logic_vector(BLOCK_SIZE - 1 downto 0);
		shifted_matrix : out std_logic_vector(BLOCK_SIZE - 1 downto 0)
	);
end component;

component column_mixer is
	generic (BLOCK_SIZE : natural);
	port (
		state_matrix : in std_logic_vector(BLOCK_SIZE - 1 downto 0);
		mixed_columns : out std_logic_vector(BLOCK_SIZE - 1 downto 0)
	);
end component;

component round_key_adder is
	generic (BLOCK_SIZE : natural);
	port (
		state_matrix : in std_logic_vector(BLOCK_SIZE - 1 downto 0);
		subkey : in std_logic_vector(KEY_SIZE - 1 downto 0);
		mixed_columns : out std_logic_vector(BLOCK_SIZE - 1 downto 0)
	);	
end component;

begin

end structural;