library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity half_adder_tb is
end;

architecture sim of half_adder_tb is
	component half_adder
		port(
			a, b: in std_logic;
			sum, cout: out std_logic
		);
	end component;
	--signal clk: std_logic:= '0';
	--signal rst: std_logic:= '1';
	
	signal input_tb: std_logic_vector(1 downto 0):= (others => '0');
	
	alias input_tb_a is input_tb(0);
	alias input_tb_b is input_tb(1);
	
	signal sum: std_logic;
	signal cout: std_logic;
begin
	--clk <= not clock after 1us;
	--rst <= '1', '0' after 5 ns;
	dut: half_adder port map(input_tb_a, input_tb_b, sum, cout);
	stimulus:
	process begin
		--wait until (rst = '0');
		input_tb <= "00";
		wait for 10 us;
		
		input_tb <= "01";
		wait for 10 us;
		
		input_tb <= "10";
		wait for 10 us;
		
		input_tb <= "11";
		wait for 10 us;
		
		wait;
	end process stimulus;
end;
