----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2022 16:05:57
-- Design Name: 
-- Module Name: instructionnMem_test - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY instrucctionMem_test IS
END instrucctionMem_test;
 
ARCHITECTURE behavior OF instrucctionMem_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instrucctionMem
    PORT(
         ADDR : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         DOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADDR : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instrucctionMem PORT MAP (
          ADDR => ADDR,
          CLK => CLK,
          DOUT => DOUT
        );

   CLK <= not CLK after 10ns;
	ADDR <= x"05" after 70ns, x"06" after 80ns;

END;
