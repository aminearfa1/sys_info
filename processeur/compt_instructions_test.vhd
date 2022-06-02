----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2022 17:15:03
-- Design Name: 
-- Module Name: compt_instructions_test - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY compt_instructions_test IS
END compt_instructions_test;
 
ARCHITECTURE behavior OF compt_instructions_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT compt_instructions_test
    PORT(
         clk : IN  std_logic;
         sens : IN  std_logic;
         load : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sens : std_logic := '0';
   signal load : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: compt_instructions_test PORT MAP (
          clk => clk,
          sens => sens,
          load => load,
          rst => rst,
          en => en,
          din => din,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      rst <= '0' after 0ns, '1' after 50 ns;
		din <= "00000000" after 0ns, "00001011" after 100ns, "00000000" after 120ns;
		sens <= '1' after 0ns, '0' after 130ns;
		en <= '1' after 50ns, '0' after 300ns;
		load <= '1' after 100ns, '0' after 110ns;

      wait;
   end process;

END;
