library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder_tb is
end;

architecture sim of full_adder_tb is
	component full_adder
		port(
			a, b, cin: in std_logic;
			sum, cout: out std_logic
		);
	end component;
	--signal clk: std_logic:= '0';
	--signal rst: std_logic:= '1';
	
	signal input_tb: std_logic_vector(2 downto 0):= (others => '0');
	
	alias input_tb_a is input_tb(0);
	alias input_tb_b is input_tb(1);
	alias input_tb_cin is input_tb(2);
	
	signal sum: std_logic;
	signal cout: std_logic;
begin
	--clk <= not clock after 1us;
	--rst <= '1', '0' after 5 ns;
	dut: full_adder port map(input_tb_a, input_tb_b, input_tb_cin, sum, cout);
	stimulus:
	process begin
		--wait until (rst = '0');
		input_tb <= "000";
		wait for 10 us;
		
		input_tb <= "001";
		wait for 10 us;
		
		input_tb <= "010";
		wait for 10 us;
		
		input_tb <= "011";
		wait for 10 us;
		
		input_tb <= "100";
		wait for 10 us;
		
		input_tb <= "101";
		wait for 10 us;
		
		input_tb <= "110";
		wait for 10 us;
		
		input_tb <= "111";
		wait for 10 us;
		
		wait;
	end process stimulus;
end;
