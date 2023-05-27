library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controller is
	port(
		clk, reset: in std_logic;
		p, r: in std_logic;
		ta, tb: in std_logic;
		la, lb: out std_logic_vector(1 downto 0)
	);
end;

architecture synth of controller is
	component mode
		port(
			clk, reset: in std_logic;
			p, r: in std_logic;
			m: out std_logic
		);
	end component;
	
	component lights
	port(
		clk, reset: in std_logic;
		ta, tb, m: in std_logic;
		la, lb: out std_logic_vector(1 downto 0)
	);
	end component;
	signal m: std_logic;
begin
	mode_module: mode port map(clk, reset, p, r, m);
	lights_module: lights port map(clk, reset, ta, tb, m, la, lb);
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mode is
	port(
		clk, reset: in std_logic;
		p, r: in std_logic;
		m: out std_logic
	);
end;

architecture struct1 of mode is
	type statetype is (S0, S1);
	signal state, nextstate: statetype;
begin
	process(clk, reset) begin
		if reset then
			state <= S0;
		elsif rising_edge(clk) then
			state <= nextstate;
		end if;
	end process;
	
	process(all) begin
		case state is
			when S0 =>
				if p then
					nextstate <= S1;
				elsif not p then
					nextstate <= S0;
				end if;
			when S1 =>
				if r then
					nextstate <= S0;
				elsif not r then
					nextstate <= S1;
				end if;
			when others =>
				nextstate <= S0;
		end case;
	end process;
	process(all) begin
		case state is
			when S0 =>
				m <= '0';
			when S1 =>
				m <= '1';
		end case;
	end process;
end;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity lights is
	port(
		clk, reset: in std_logic;
		ta, tb, m: in std_logic;
		la, lb: out std_logic_vector(1 downto 0)
	);
end;

architecture struct2 of lights is
	type statetype is (S0, S1, S2, S3);
	signal state, nextstate: statetype;
begin
	process(clk, reset) begin
		if reset then
			state <= S0;
		elsif rising_edge(clk) then
			state <= nextstate;
		end if;
	end process;
	
	process(all) begin
		case state is
			when S0 =>
				if ta then
					nextstate <= S0;
				elsif not ta then
					nextstate <= S1;
				end if;
			when S1 =>
				nextstate <= S2;
			when S2 =>
				if (tb or m) then
					nextstate <= S2;
				elsif not(tb or m) then
					nextstate <= S3;
				end if;
			when S3 =>
				nextstate <= S0;
			when others =>
				nextstate <= S0;
		end case;
	end process;
	process(all) begin
		case state is
			when S0 =>
				la <= "00";
				lb <= "10";
			when S1 =>
				la <= "01";
				lb <= "10";
			when S2 =>
				la <= "10";
				lb <= "00";
			when S3 =>
				la <= "10";
				lb <= "01";
		end case;
	end process;
end;
