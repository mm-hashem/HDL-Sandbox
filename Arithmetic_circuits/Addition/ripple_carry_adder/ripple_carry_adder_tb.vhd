library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RCA_4B_tb is
end;

architecture sim of RCA_4B_tb is
	component RCA_4B
		port(
		a, b: in std_logic_vector(3 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(3 downto 0);
		cout_out: out std_logic
		);
	end component;
	--signal clk: std_logic:= '0';
	--signal rst: std_logic:= '1';
	
	signal ip_tb_a: std_logic_vector(3 downto 0);
	signal ip_tb_b: std_logic_vector(3 downto 0);
	signal ip_tb_cin: std_logic;
	signal op_tb_sum: std_logic_vector(3 downto 0);
	signal op_tb_cout: std_logic;
	
begin
	--clk <= not clock after 1us;
	--rst <= '1', '0' after 5 ns;
	dut: RCA_4B port map(ip_tb_a, ip_tb_b, ip_tb_cin, op_tb_sum, op_tb_cout);
	stimulus:
	process begin
		--wait until (rst = '0');
		ip_tb_a <= "1011";
		ip_tb_b <= "1100";
		ip_tb_cin <= '1';
		wait for 10ns;
		
		wait;
	end process stimulus;
end;
