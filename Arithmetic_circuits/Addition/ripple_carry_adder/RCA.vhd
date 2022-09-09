---------4-bit RCA, an implementation of CPA----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RCA_4B is
	port(
		a, b: in std_logic_vector(3 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(3 downto 0);
		cout_out: out std_logic
	);
end;

architecture synth of RCA_4B is
	component FA_1B
	port(
		a, b, cin: in std_logic;
		sum, cout: out std_logic
	);
	end component;
	signal cout_internal: std_logic_vector(3 downto 0);
begin
	FA_4B_0: FA_1B port map(a(0), b(0), cin,              sum(0), cout_internal(0));
	FA_4B_1: FA_1B port map(a(1), b(1), cout_internal(0), sum(1), cout_internal(1));
	FA_4B_2: FA_1B port map(a(2), b(2), cout_internal(1), sum(2), cout_internal(2));
	FA_4B_3: FA_1B port map(a(3), b(3), cout_internal(2), sum(3), cout_out);
end;

---------1-bit FULL ADDER----------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FA_1B is
	port(
		a, b, cin: in std_logic;
		sum, cout: out std_logic
	);
end;

architecture synth of FA_1B is
begin
	cout <= (a and b) or (a and cin) Or (cin and b);
	sum <= a xor b xor cin;
end;
