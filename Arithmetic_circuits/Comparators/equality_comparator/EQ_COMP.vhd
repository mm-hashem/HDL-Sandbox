library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity EQ_COMP is
	port(
		a, b: in std_logic_vector(3 downto 0);
		isEqual: out std_logic
	);
end;

architecture synth of EQ_COMP is
	signal n0, n1, n2, n3: std_logic;
begin
	n0 <= a(0) xnor b(0);
	n1 <= a(1) xnor b(1);
	n2 <= a(2) xnor b(2);
	n3 <= a(3) xnor b(3);
	isEqual <= n0 and n1 and n2 and n3;
end;
