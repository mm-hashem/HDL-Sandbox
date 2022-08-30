library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity priority_circuit is
	port(
		a: in std_logic_vector(7 downto 0);
		y: out std_logic_vector(7 downto 0)
	);
end priority_circuit;

architecture synth of priority_circuit is
begin
	process(all) begin
		case? a is
			when "1-------" => y <= "10000000";
			when "01------" => y <= "01000000";
			when "001-----" => y <= "00100000";
			when "0001----" => y <= "00010000";
			when "00001---" => y <= "00001000";
			when "000001--" => y <= "00000100";
			when "0000001-" => y <= "00000010";
			when "00000001" => y <= "00000001";
			when others  => y <= "00000000";
		end case?;
	end process;
end synth;
