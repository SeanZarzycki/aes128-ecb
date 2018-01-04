library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity row_shifter is
   -- generic (ROWNUM : natural := 0);
    port (
        state : in cipherblock;
        shifted : out cipherblock
    );
end row_shifter;

architecture beh of row_shifter is

begin
    shifted <= ShiftRows(state);
end beh;