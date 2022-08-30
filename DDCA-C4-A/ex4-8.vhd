library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux8 is
	port(
    d0, d1, d2, d3,
		d4, d5, d6, d7: in std_logic;
		s: in std_logic_vector(2 downto 0);
		y: out std_logic
	);
end mux8;

architecture struct of mux8 is
begin
	with s select y <=
		d0 when "000",
		d1 when "001",
		d2 when "010",
		d3 when "011",
		d4 when "100",
		d5 when "101",
		d6 when "110",
		d7 when "111";
end struct;
