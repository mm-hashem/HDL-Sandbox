library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SUB_4B_tb is
end;

architecture sim of SUB_4B_tb is
	component SUB_4B
		port(
			a, b: in std_logic_vector(3 downto 0);
			sub: out std_logic_vector(3 downto 0)
		);
	end component;
	
	signal ip_tb_a: std_logic_vector(3 downto 0);
	signal ip_tb_b: std_logic_vector(3 downto 0);
	signal op_tb_sub: std_logic_vector(3 downto 0);
	
begin
	dut: SUB_4B port map(ip_tb_a, ip_tb_b, op_tb_sub);
	stimulus:
	process begin
		ip_tb_a <= "0111";
		ip_tb_b <= "0101";
		wait for 10ns;
		
		ip_tb_a <= "1111";
		ip_tb_b <= "0101";
		wait for 10ns;
		
		ip_tb_a <= "0110";
		ip_tb_b <= "0101";
		wait for 10ns;
		
		ip_tb_a <= "1111";
		ip_tb_b <= "1110";
		wait for 10ns;
		
		wait;
	end process stimulus;
end;
