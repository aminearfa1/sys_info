----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2022 11:42:13
-- Design Name: 
-- Module Name: test_banc_memoire_donnee - Behavioral
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

entity test_banc_memoire_donnee is
--  Port ( );
end test_banc_memoire_donnee;

architecture Behavioral of test_banc_memoire_donnee is

   -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataMemBench
    PORT(
         Addr : IN  std_logic_vector(7 downto 0);
         IN_V : IN  std_logic_vector(7 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         OUT_V : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_V : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_V : std_logic_vector(7 downto 0);
   
BEGIN
    
       -- Instantiate the Unit Under Test (UUT)
      uut: DataMemBench PORT MAP (
             Addr => Addr,
             IN_V => IN_V,
             RW => RW,
             RST => RST,
             CLK => CLK,
             OUT_V => OUT_V
           );
   
      CLK <= not CLK after 50ns;
       RST <= '1' after 200ns, '0' after 600ns;
       RW <= '1' after 200ns, '0' after 400ns;
       IN_V <= x"AA" after 300ns;
       Addr <= x"05" after 300ns;
   
   END;