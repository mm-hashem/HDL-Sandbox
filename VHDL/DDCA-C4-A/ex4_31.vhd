library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity seq_circuit is
	port(
		clk: in std_logic;
		a, b, c, d: in std_logic;
		x, y: out std_logic
	);
end;

architecture synth of seq_circuit is
	component reg
	port(
		clk: in std_logic;
		d: in std_logic;
		q: out std_logic
	);
	end component;
	signal n1, xo, yo: std_logic;
	signal ao, bo, co, do: std_logic;
begin
	regA: reg port map(clk, a, ao);
	regB: reg port map(clk, b, bo);
	n1 <= ao and bo;
	regC: reg port map(clk, c, co);
	xo <= co or n1;
	regD: reg port map(clk, d, do);
	yo <= xo nor do;
	regX: reg port map(clk, xo, x);
	regY: reg port map(clk, yo, y);
end;
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg is
	port(
		clk: in std_logic;
		d: in std_logic;
		q: out std_logic
	);
end;

architecture synth of reg is
begin
	process(clk) begin
		if rising_edge(clk) then
			q <= d;
		end if;
	end process;
end;
