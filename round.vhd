library ieee;
use ieee.std_logic_1164.all;

use work.aes_pkg.all;

entity round is
port (
    x : in cipherblock;
    y : out cipherblock;
    subkey : in cipherkey
);

end round;


architecture beh of round is

type coltype is array(0 to 3) of word;
signal cols : coltype;
signal mixed : cipherblock;

component column_mixer
    generic (c : natural := 0);
    port (
        state : in cipherblock;
        mixed : out cipherblock
    );
end component;

signal shifted : cipherblock;
component row_shifter
   -- generic (ROWNUM : natural := 0);
    port (
        state : in cipherblock;
        shifted : out cipherblock
    );
end component;

signal subbed : cipherblock;
component state_sbox
    port ( 
        x : in cipherblock;
        z : out cipherblock
    );
end component;

signal key_added : cipherblock;
component key_adder
    port (
        x : in cipherblock;
        key : in cipherkey;
        z : out cipherblock
    );
end component;


begin
    
    SUB_BOX : state_sbox 
        port map (x => x, z => subbed);


   -- GEN_SHIFT_ROWS : for r in 0 to 3 generate
        SHIFT_ROW : row_shifter 
           -- generic map(ROWNUM => r)
            port map(state => subbed, shifted => shifted);
  --  end generate GEN_SHIFT_ROWS;

  --  GEN_MIX_COLUMNS : for c in 0 to 3 generate
    MIX_COLUMN : column_mixer 
       -- generic map(c => c)
        port map(state => shifted,
                 mixed => mixed);
   -- end generate GEN_MIX_COLUMNS;

    ADD_ROUNDKEY : key_adder 
        port map(x => mixed, key => subkey, z => y);


    
end beh;

