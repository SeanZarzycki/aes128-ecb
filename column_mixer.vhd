library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.aes_pkg.all;

entity column_mixer is
    -- generic (colnum : natural := 0);
	port (
		state  : in cipherblock;
		mixed : out cipherblock
	);
end column_mixer;

architecture beh of column_mixer is
begin    
    mixed <= mixcolumns(state);
end beh;