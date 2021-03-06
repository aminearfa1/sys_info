----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2022 16:03:13
-- Design Name: 
-- Module Name: InstructionMem - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instrucctionMem is
	 Generic ( SIZE : Natural := 8;
				  SIZE_DOUT : Natural := 32);
    Port ( ADDR : in  STD_LOGIC_VECTOR (SIZE-1 downto 0);
           CLK : in  STD_LOGIC;
           OUT_v : out  STD_LOGIC_VECTOR (SIZE_DOUT-1 downto 0));
end instrucctionMem;

architecture Behavioral of instrucctionMem is
	TYPE MEMORY IS ARRAY (0 to (15)) OF STD_LOGIC_VECTOR (SIZE_DOUT-1 downto 0);
	signal ROM : MEMORY := (0=>x"01020304", 1=>x"05060708", others => (others => '0'));
	signal memOut : STD_LOGIC_VECTOR (SIZE_DOUT-1 downto 0);
begin
	OUT_v <= memOut;

	instbench : process (CLK) is
	begin
		if rising_edge(CLK) then
			memOut <= ROM(conv_integer(ADDR));
		end if;
	end process;

end Behavioral;