---------4-bit Magnitude Comparator----------
-- How it works?
-- It uses Two's Complement method to compute the subtraction of B from A.
-- If the output isLess is 1, then A is less than B.
-- If the output isLess is 0, then A is greater than B.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MGNT_COMP_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		isLess: out std_logic
	);
end;

architecture synth of MGNT_COMP_4B is
	component SUB_1B
	port(
		a, b, cin: in std_logic;
		sub, cout: out std_logic
	);
	end component;
	signal cout_internal: std_logic_vector(3 downto 0);
begin
	SUB_4B_0: SUB_1B port map(a(0), not b(0), '1',              open, cout_internal(0));
	SUB_4B_1: SUB_1B port map(a(1), not b(1), cout_internal(0), open, cout_internal(1));
	SUB_4B_2: SUB_1B port map(a(2), not b(2), cout_internal(1), open, cout_internal(2));
	SUB_4B_3: SUB_1B port map(a(3), not b(3), cout_internal(2), isLess, open);
end;

---------1-bit Subtractor----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SUB_1B is
	port(
		a, b, cin: in std_logic;
		sub, cout: out std_logic
	);
end;

architecture synth of SUB_1B is
begin
	cout <= (a and b) or (a and cin) Or (cin and b);
	sub <= a xor b xor cin;
end;
