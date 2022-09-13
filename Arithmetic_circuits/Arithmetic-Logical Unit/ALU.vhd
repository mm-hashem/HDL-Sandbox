-- How it works?
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		ctrl: in std_logic_vector(2 downto 0);
		op: out std_logic_vector(3 downto 0)
	);
end;

architecture synth of ALU_4B is
	component CLAA_4B
		port(
			a, b: in std_logic_vector(3 downto 0);
			cin: in std_logic;
			sum: out std_logic_vector(3 downto 0);
			cout_out: out std_logic
		);
	end component;
	component SUB_4B
		port(
			a, b: in std_logic_vector(3 downto 0);
			sub: out std_logic_vector(3 downto 0)
		);
	end component;
	signal ADDER_sum: std_logic_vector(3 downto 0);
	--signal ADDER_cout: std_logic;
	signal SUB_sub: std_logic_vector(3 downto 0);
begin
	ADDER: CLAA_4B port map(a, b, '0', ADDER_sum, open);
	SUB: SUB_4B port map(a, b, SUB_sub);
	process(all) begin
		case ctrl is
			when "000" =>
				op <= a and b;
			when "001" =>
				op <= a or b;
			when "010" =>
				op <= ADDER_sum;
			when "011" =>
				op <= "1111";
			when "100" =>
				op <= a and (not b);
			when "101" =>
				op <= a or (not b);
			when "110" =>
				op <= SUB_sub;
			when "111" =>
				op <= "000" & SUB_sub(3);
			when others =>
				op <= "1111";
		end case;
	end process;
end;

---------4-bit Adder----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLAA_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(3 downto 0);
		cout_out: out std_logic
	);
end;

architecture synth of CLAA_4B is
	component CLAA_1B
		port(
			a, b, cin: in std_logic;
			sum: out std_logic;
			p, g: out std_logic
		);
	end component;
	signal p, g: std_logic_vector(3 downto 0);
	signal cout_0, cout_1, cout_2: std_logic;
begin
	cout_0 <=   g(0)  or (p(0) and cin);
	cout_1 <=   (g(1) or (p(1) and g(0))) or (p(1) and p(0) and cin);
	cout_2 <=   (g(2) or (p(2) and (g(1)  or (p(1) and g(0))))) or (p(2) and p(1) and p(0) and cin);
	cout_out <= (g(3) or (p(3) and (g(2)  or (p(2) and (g(1) or (p(1) and g(0))))))) or (p(3) and p(2) and p(1) and p(0) and cin);
	
	CLAA_4B_0: CLAA_1B port map(a(0), b(0), cin,    sum(0), p(0), g(0));
	CLAA_4B_1: CLAA_1B port map(a(1), b(1), cout_0, sum(1), p(1), g(1));
	CLAA_4B_2: CLAA_1B port map(a(2), b(2), cout_1, sum(2), p(2), g(2));
	CLAA_4B_3: CLAA_1B port map(a(3), b(3), cout_2, sum(3), p(3), g(3));
end;
---------1-bit Adder----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLAA_1B is
	port(
		a, b, cin: in std_logic;
		sum: out std_logic;
		p, g: out std_logic
	);
end;

architecture synth of CLAA_1B is

begin
	p <= a or b;
	g <= a and b;
	sum <= a xor b xor cin;
end;
---------4-bit Subtractor----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SUB_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		sub: out std_logic_vector(3 downto 0)
	);
end;

architecture synth of SUB_4B is
	component SUB_1B
		port(
			a, b, cin: in std_logic;
			sub, cout: out std_logic
		);
	end component;
	signal cout_internal: std_logic_vector(3 downto 0);
begin
	SUB_4B_0: SUB_1B port map(a(0), not b(0), '1',              sub(0), cout_internal(0));
	SUB_4B_1: SUB_1B port map(a(1), not b(1), cout_internal(0), sub(1), cout_internal(1));
	SUB_4B_2: SUB_1B port map(a(2), not b(2), cout_internal(1), sub(2), cout_internal(2));
	SUB_4B_3: SUB_1B port map(a(3), not b(3), cout_internal(2), sub(3), open);
end;

---------1-bit Subtractor----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SUB_1B is
	port(
		a, b, cin: in std_logic;
		sub, cout: out std_logic
	);
end;

architecture synth of SUB_1B is
begin
	cout <= (a and b) or (a and cin) Or (cin and b);
	sub <= a xor b xor cin;
end;
