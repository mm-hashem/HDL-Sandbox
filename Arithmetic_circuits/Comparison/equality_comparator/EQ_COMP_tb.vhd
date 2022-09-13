library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity EQ_COMP_tb is
end;

architecture sim of EQ_COMP_tb is
	component EQ_COMP
		port(
			a, b: in std_logic_vector(3 downto 0);
			isEqual: out std_logic		
		);
	end component;
	
	signal ip_tb_a: std_logic_vector(3 downto 0);
	signal ip_tb_b: std_logic_vector(3 downto 0);
	signal op_tb_isEqual: std_logic;
	
begin
	dut: EQ_COMP port map(ip_tb_a, ip_tb_b, op_tb_isEqual);
	stimulus:
	process begin
		ip_tb_a <= "0101";
		ip_tb_b <= "1010";
		wait for 10ns;
		
		ip_tb_a <= "1111";
		ip_tb_b <= "1111";
		wait for 10ns;
		
		ip_tb_a <= "0001";
		ip_tb_b <= "0001";
		wait for 10ns;
		
		ip_tb_a <= "1111";
		ip_tb_b <= "1110";
		wait for 10ns;
		
		wait;
	end process stimulus;
end;
