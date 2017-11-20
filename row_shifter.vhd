library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity row_shifter is
	port (
		row : in matrix;
        row_num : in integer;
		shifted : out matrix
	);
end row_shifter;

architecture beh of row_shifter is

begin
    process(row)
    begin
        for i in 0 to MATRIX_DIM - 1 loop
            shifted((i - row_num + MATRIX_DIM) mod MATRIX_DIM) <= state_matrix(i);
        end loop;
    end process;
end beh;