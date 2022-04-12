--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:42:53 04/01/2016
-- Design Name:   
-- Module Name:   /home/laine/Documents/4a/compilo/projet_si/processeur/ALU_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_test IS
END ALU_test;
 
ARCHITECTURE behavior OF ALU_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  STD_LOGIC_VECTOR(7 downto 0);
         B : IN  STD_LOGIC_VECTOR(7 downto 0);
         Ctrl_Alu : IN  std_logic_vector(2 downto 0);
         S : OUT  STD_LOGIC_VECTOR(7 downto 0);
         N : OUT  std_logic;
         O : OUT  std_logic;
         Z : OUT  std_logic;
         C : OUT  std_logic
        );
    END COMPONENT;
    

   --les éntrées
   signal A : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal B : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal Ctrl_Alu : std_logic_vector(2 downto 0) := (others => '0');
 	--les sorties
   signal S : STD_LOGIC_VECTOR(7 downto 0);
   signal N : std_logic;
   signal O : std_logic;
   signal Z : std_logic;
   signal C : std_logic;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Ctrl_Alu => Ctrl_Alu,
          S => S,
          N => N,
          O => O,
          Z => Z,
          C => C
        );
		  

   process
   begin		
   
			
   end process;
	   -- hold reset state for 100 ns.
        A <= "00111111"; 
        B <= "00000011";
        Ctrl_Alu <= "010";
       
     

END;