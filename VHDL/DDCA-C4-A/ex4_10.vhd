library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity logic_fun is
	port(
		a, b, c: in std_logic;
		y: out std_logic
	);
end logic_fun;

architecture synth of logic_fun is
	component mux4 is
		port(
			s: in std_logic_vector(1 downto 0);
			d0, d1, d2, d3: in std_logic;
			y: out std_logic
		);
	end component mux4;
begin
	mux4_op: mux4 port map(a & b, not c, c, '1', '0', y);
end synth;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux4 is
	port(
		s: in std_logic_vector(1 downto 0);
		d0, d1, d2, d3: in std_logic;
		y: out std_logic
	);
end mux4;

architecture struct of mux4 is
begin
	with s select y <=
		d0 when "00",
		d1 when "01",
		d2 when "10",
		d3 when "11";
end struct;
