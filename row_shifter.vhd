library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity row_shifter is
	port (
		state_matrix : in matrix;
		shifted_matrix : out matrix
	);
end row_shifter;

architecture beh of row_shifter is
signal shifted_result : matrix;
begin
    process(state_matrix)
    begin
        for n in 0 to MATRIX_DIM - 1 loop
            shifted_matrix(0, n) <= state_matrix(0, n);
        end loop;
        
        for i in 1 to MATRIX_DIM - 1 loop -- skip first row
            for j in 0 to MATRIX_DIM - 1 loop
                shifted_matrix(i, (j - i + MATRIX_DIM) mod MATRIX_DIM) <= state_matrix(i, j);
            end loop;
        end loop;
        
    end process;
end beh;