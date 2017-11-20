library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.aes_pkg.all;

entity column_mixer is
	port (
		col  : in word;
		mixed : out word
	);
end column_mixer;

architecture beh of column_mixer is

begin
    
    process(col)

    begin

        mixed(0) <= col(0)(6 downto 0) & "0" xor ((7 downto 0 => col(0)(7)) and x"1b") xor
                                col(3) xor
                                col(2) xor
                                col(1)(6 downto 0) & "0" xor ((7 downto 0 => col(1)(7)) and x"1b") xor
                                col(1);
        
        mixed(1) <= col(1)(6 downto 0) & "0" xor ((7 downto 0 => col(1)(7)) and x"1b") xor
                    col(0) xor
                    col(3) xor
                    col(2)(6 downto 0) & "0" xor ((7 downto 0 => col(2)(7)) and x"1b") xor
                    col(2);
        
        mixed(2) <= col(2)(6 downto 0) & "0" xor ((7 downto 0 => col(2)(7)) and x"1b") xor
                    col(1) xor
                    col(0) xor
                    col(3)(6 downto 0) & "0" xor ((7 downto 0 => col(3)(7)) and x"1b") xor
                    col(3);

        mixed(3) <= col(3)(6 downto 0) & "0" xor ((7 downto 0 => col(3)(7)) and x"1b") xor
                    col(2) xor
                    col(1) xor
                    col(0)(6 downto 0) & "0" xor ((7 downto 0 => col(0)(7)) and x"1b") xor
                    col(0);          
        
    end process;
end beh;