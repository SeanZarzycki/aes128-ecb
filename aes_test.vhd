library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.aes_pkg.all;
use work.aes_ecb_breaker.all;

entity AES_TESTBENCH is
end AES_TESTBENCH;

architecture tb of AES_TESTBENCH is

    begin
        process
        variable key : cipherkey :=  (x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");
        variable unknown : cipherblock := (x"80",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");
        variable ciphertext : cipherblock;
        variable recovered : cipherblock;

        begin
            ciphertext := cipher(unknown, key);
            recovered := oracle_ecb_decrypt(unknown, key);

        end process;

    end tb;