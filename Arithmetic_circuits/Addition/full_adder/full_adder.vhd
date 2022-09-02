library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder is
	port(
		a, b, cin: in std_logic;
		sum, cout: out std_logic
	);
end;

architecture synth of full_adder is
begin
	cout <= (a and b) or (a and cin) Or (cin and b);
	sum <= a xor b xor cin;
end;
