library ieee;
use ieee.std_logic_1164.all;

use work.aes_pkg.all;

entity key_adder is
    port (
        x : in cipherblock;
        key : in cipherkey;
        z : out cipherblock
    );
end key_adder;

architecture struc of key_adder is
begin

    GEN_KEY_ADDER : for i in 0 to 15 generate
        z(i) <= x(i) XOR key(i);
    end generate GEN_KEY_ADDER;

end struc;