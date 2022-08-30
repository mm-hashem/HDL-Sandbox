library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity logic_equs is
	port(
		a, b, c, d: in std_logic;
		x: out std_logic;
		y: out std_logic;
		z: out std_logic
	);
end logic_equs;

architecture synth of logic_equs is
begin
	x <= (a and c)
	or ((not a) and (not b) and (not c));
	
	y <= ((not a) and (not b))
	or ((not a) and b and (not c))
	or not(a or (not c));
	
	z <= ((not a) and (not b) and (not c) and (not d))
	or (a and (not b) and (not c))
	or (a and (not b) and c and (not d))
	or (a and b and d)
	or ((not a) and (not b) and c and (not d))
	or (b and (not c) and d)
	or (not a);
end synth;
