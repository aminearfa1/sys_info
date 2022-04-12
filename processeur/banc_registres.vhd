----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 10:27:46
-- Design Name: 
-- Module Name: banc_registres - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;




entity banc_registres is
    Generic ( SIZE : Natural := 8;
				  REG_SIZE : Natural :=4;
				  NB_REGISTERS : Natural := 16);
				  
    Port ( addrA : in STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
           addrB : in STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
           addrW : in STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (SIZE-1 downto 0);
           QB : out STD_LOGIC_VECTOR (SIZE-1 downto 0));
end banc_registres;

architecture Behavioral of banc_registres is

TYPE REGISTERS IS ARRAY (0 to (NB_REGISTERS-1)) OF STD_LOGIC_VECTOR (SIZE-1 downto 0);
	signal R : REGISTERS := (others => (others => '0'));
	signal MAddrA : STD_LOGIC_VECTOR (REG_SIZE-1 downto 0) := (others => '0');
	signal MAddrB : STD_LOGIC_VECTOR (REG_SIZE-1 downto 0) := (others => '0');

begin

	QA <= R(conv_integer(MAddrA));   --convert the argument to an integer
	QB <= R(conv_integer(MAddrB));
	
	banc_reg : process (CLK) is
        begin
            if rising_edge(CLK) then
                if RST = '0' then
                    R <= (others => (others => '0'));
                else
                    MAddrA <= addrA;
                    MAddrB <= addrB;
                    if W = '1' then
                        R(conv_integer(addrW)) <= DATA;
                    end if;
                end if;
            end if;
        end process;

end Behavioral;
