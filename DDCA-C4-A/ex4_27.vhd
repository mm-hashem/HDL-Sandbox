library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity jkff is
	port(
		clk: in std_logic;
		j, k: in std_logic;
		q: out std_logic
	);
end jkff;

architecture synth of jkff is
begin
	process(clk) begin
		if rising_edge(clk) then
			if j = '0' and k = '1' then
				q <= '0';
			elsif j = '1' and k = '0' then
				q <= '1';
			elsif j = '1' and k = '1' then
				q <= not q;
			end if;
		end if;
	end process;
end synth;
