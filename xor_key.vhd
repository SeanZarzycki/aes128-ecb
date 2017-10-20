-- xor_key xors a plaintext by a key

library ieee;
use ieee.std_logic_1164.all;

entity XOR_KEY is
    generic (
        KEY_LEN  : integer := 2;
        TEXT_LEN : integer := 4
    );
    port (
        key       : in std_logic_vector(KEY_LEN-1 downto 0);
        plaintext : in std_logic_vector(TEXT_LEN-1 downto 0);
        cipher    : out std_logic_vector(TEXT_LEN-1 downto 0)
    );

end XOR_KEY;

architecture structural of XOR_KEY is

component XOR_N
    generic (N : integer := KEY_LEN);
    port (
        key       : in std_logic_vector(KEY_LEN - 1 downto 0);
        plaintext : in std_logic_vector(KEY_LEN - 1 downto 0);
        cipher    : out std_logic_vector(KEY_LEN - 1 downto 0)
    );
end component;

begin

    XOR_GEN : for i in 0 to (TEXT_LEN / KEY_LEN - 1) generate
        XOR_N_GEN : XOR_N 
            generic map (N => KEY_LEN)
            port map(
            key => key, 
            plaintext => plaintext((i + 1) * KEY_LEN - 1 downto i * KEY_LEN),
            cipher => cipher((i + 1) * KEY_LEN - 1 downto i * KEY_LEN));
    end generate XOR_GEN;
    

end structural;
