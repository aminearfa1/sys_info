----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:08:50
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	 Generic (T : integer := 8);
    Port ( A : in STD_LOGIC_VECTOR (T-1 downto 0);
           B : in STD_LOGIC_VECTOR (T-1 downto 0);
           Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           S : out STD_LOGIC_VECTOR (T-1 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

	--Ri le résultat, Ri et Rj sont les opérations.
	
signal Ri: STD_LOGIC_VECTOR((2*T)-1 downto 0) := (others => '0');
signal Rj, Rk: STD_LOGIC_VECTOR(T downto 0) := (others => '0');

begin
Rj <= "0"&A;
Rk <= "0"&B;
S <= Ri(T-1 downto 0);
alu : process(Rj, Rk, Ctrl_Alu)

begin
	case(Ctrl_Alu) is
		when "001" => -- Addition
			Ri <= b"0000000"&(Rj + Rk);
		when "010" => -- Multiplication
			Ri <= Rj(T-1 downto 0) * Rk(T-1 downto 0);
		when "011" => -- Soustraction
			Ri <= b"0000000"&(Rj - Rk);
		when "100" => -- Division
		    --   Ri <= (Rj/Rk);
		when others => NULL;
	end case;

end process;





end Behavioral;
