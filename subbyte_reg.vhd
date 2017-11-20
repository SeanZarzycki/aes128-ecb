library ieee;
use ieee.std_logic_1164.all;

library work;
use work.aes_pkg.all;

entity subbyte_reg is
	port (
		state_matrix : in matrix;
		subbyte_matrix : out matrix
	);

end subbyte_reg;

architecture beh of subbyte_reg is

begin

end beh;