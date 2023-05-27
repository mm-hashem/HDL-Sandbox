library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MGNT_COMP_4B_tb is
end;

architecture sim of MGNT_COMP_4B_tb is
	component MGNT_COMP_4B
		port(
			a, b: in std_logic_vector(3 downto 0);
			isLess: out std_logic
		);
	end component;
	
	signal ip_tb_a: std_logic_vector(3 downto 0);
	signal ip_tb_b: std_logic_vector(3 downto 0);
	signal op_tb_isLess: std_logic;
	
begin
	dut: MGNT_COMP_4B port map(ip_tb_a, ip_tb_b, op_tb_isLess);
	stimulus:
	process begin
		ip_tb_a <= "0111";
		ip_tb_b <= "1000";
		wait for 10ns;
		
		ip_tb_a <= "0111";
		ip_tb_b <= "0011";
		wait for 10ns;
				
		wait;
	end process stimulus;
end;
