library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity half_adder is
	port(
		a, b: in std_logic;
		sum, cout: out std_logic
	);
end;

architecture synth of half_adder is
begin
	sum <= a xor b;
	cout <= a and b;
end;
