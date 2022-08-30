library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decoder2to4 is
	port(
		a: in std_logic_vector(1 downto 0);
		y: out std_logic_vector(3 downto 0)
	);
end decoder2to4;

architecture synth of decoder2to4 is
begin
	with a select y <=
		"1000" when "00",
		"0100" when "01",
		"0010" when "10",
		"0001" when "11";
end synth;
