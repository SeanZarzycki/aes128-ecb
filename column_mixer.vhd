library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.aes_pkg.all;

entity column_mixer is
	port (
		state_matrix  : in matrix;
		mixed_columns : out matrix
	);
end column_mixer;

architecture beh of column_mixer is

begin
    
    process(state_matrix)

    begin
        for j in 0 to MATRIX_DIM - 1 loop

            mixed_columns(0, j) <= state_matrix(0, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(0, j)(7)) and x"1b") xor
                                   state_matrix(3, j) xor
                                   state_matrix(2, j) xor
                                   state_matrix(1, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(1, j)(7)) and x"1b") xor
                                   state_matrix(1, j);
            
            mixed_columns(1, j) <= state_matrix(1, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(1, j)(7)) and x"1b") xor
                        state_matrix(0, j) xor
                        state_matrix(3, j) xor
                        state_matrix(2, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(2, j)(7)) and x"1b") xor
                        state_matrix(2, j);
            
            mixed_columns(2, j) <= state_matrix(2, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(2, j)(7)) and x"1b") xor
                        state_matrix(1, j) xor
                        state_matrix(0, j) xor
                        state_matrix(3, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(3, j)(7)) and x"1b") xor
                        state_matrix(3, j);

            mixed_columns(3, j) <= state_matrix(3, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(3, j)(7)) and x"1b") xor
                        state_matrix(2, j) xor
                        state_matrix(1, j) xor
                        state_matrix(0, j)(6 downto 0) & "0" xor ((7 downto 0 => state_matrix(0, j)(7)) and x"1b") xor
                        state_matrix(0, j);          
        end loop;
        
    end process;
end beh;