library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU_4B_tb is
end;

architecture sim of ALU_4B_tb is
	component ALU_4B
		port(
			a, b: in std_logic_vector(3 downto 0);
			ctrl: in std_logic_vector(2 downto 0);
			op: out std_logic_vector(3 downto 0)
		);
	end component;
	
	signal ip_tb_a: std_logic_vector(3 downto 0);
	signal ip_tb_b: std_logic_vector(3 downto 0);
	signal ip_tb_ctrl: std_logic_vector(2 downto 0);
	signal op_tb_op: std_logic_vector(3 downto 0);
	
begin
	dut: ALU_4B port map(ip_tb_a, ip_tb_b, ip_tb_ctrl, op_tb_op);
	stimulus:
	process begin
		----- AND --------
		ip_tb_a <= "1111";
		ip_tb_b <= "1111";
		ip_tb_ctrl <= "000";
		wait for 10ns;
		
		ip_tb_a <= "1010";
		ip_tb_b <= "0101";
		ip_tb_ctrl <= "000";
		wait for 10ns;
		------- OR -------------
		ip_tb_a <= "1111";
		ip_tb_b <= "1111";
		ip_tb_ctrl <= "001";
		wait for 10ns;
		
		ip_tb_a <= "1010";
		ip_tb_b <= "0101";
		ip_tb_ctrl <= "001";
		wait for 10ns;
		------ ADD -------
		ip_tb_a <= "0011";
		ip_tb_b <= "0010";
		ip_tb_ctrl <= "010";
		wait for 10ns;
		
		ip_tb_a <= "0101";
		ip_tb_b <= "0011";
		ip_tb_ctrl <= "010";
		wait for 10ns;
		--- AND NOT--------
		ip_tb_a <= "1111";
		ip_tb_b <= "1111";
		ip_tb_ctrl <= "100";
		wait for 10ns;
		
		ip_tb_a <= "1111";
		ip_tb_b <= "0000";
		ip_tb_ctrl <= "100";
		wait for 10ns;
		----- OR NOT----------
		ip_tb_a <= "1010";
		ip_tb_b <= "0101";
		ip_tb_ctrl <= "101";
		wait for 10ns;
		
		ip_tb_a <= "0101";
		ip_tb_b <= "1010";
		ip_tb_ctrl <= "101";
		wait for 10ns;
		------ SUB-----
		ip_tb_a <= "0111";
		ip_tb_b <= "1000";
		ip_tb_ctrl <= "110";
		wait for 10ns;
		
		ip_tb_a <= "0101";
		ip_tb_b <= "0011";
		ip_tb_ctrl <= "110";
		wait for 10ns;
		------ SLT-----
		ip_tb_a <= "0111";
		ip_tb_b <= "1000";
		ip_tb_ctrl <= "111";
		wait for 10ns;
		
		ip_tb_a <= "0101";
		ip_tb_b <= "0011";
		ip_tb_ctrl <= "111";
		wait for 10ns;
		-------------------
		wait;
	end process stimulus;
end;
