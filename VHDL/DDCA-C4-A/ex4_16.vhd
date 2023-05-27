library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity nand_circuit is
	port(
		a, b, c, d, e: in std_logic;
		y: out std_logic
	);
end nand_circuit;

architecture synth of nand_circuit is
begin
	y <= not(not(not(a and b) and not(c and d)) and e);
end synth;
