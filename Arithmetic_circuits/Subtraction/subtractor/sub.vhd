---------4-bit Subtractor----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SUB_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		sub: out std_logic_vector(3 downto 0)
	);
end;

architecture synth of SUB_4B is
	component SUB_1B
	port(
		a, b, cin: in std_logic;
		sub, cout: out std_logic
	);
	end component;
	signal cout_internal: std_logic_vector(3 downto 0);
begin
	FS_4B_0: SUB_1B port map(a(0), not b(0), '1',              sub(0), cout_internal(0));
	FS_4B_1: SUB_1B port map(a(1), not b(1), cout_internal(0), sub(1), cout_internal(1));
	FS_4B_2: SUB_1B port map(a(2), not b(2), cout_internal(1), sub(2), cout_internal(2));
	FS_4B_3: SUB_1B port map(a(3), not b(3), cout_internal(2), sub(3), open);
end;

---------1-bit FULL SUBTRACTOR----------
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
