-- xor_m xors 2 vectors, both of length m

library ieee;
use ieee.std_logic_1164.all;

entity XOR_N is
    generic (N : integer := 2);
    port (
        key       : in std_logic_vector(N - 1 downto 0);
        plaintext : in std_logic_vector(N - 1 downto 0);
        cipher    : out std_logic_vector(N - 1 downto 0));
end XOR_N;

architecture behavioral of XOR_N is
signal cipher_result : std_logic_vector(N - 1 downto 0);
begin
    
    process(key, plaintext)
    begin
        for i in N - 1 downto 0 loop
            cipher_result(i) <= key(i) xor plaintext(i);
        end loop;
    end process;
    cipher <= cipher_result;
end behavioral;