----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2022 10:08:01
-- Design Name: 
-- Module Name: Banc_Memoire_Donnnees - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Banc_Memoire_Donnnees is
        Generic (Size : Natural :=8);
    Port ( Addr : in STD_LOGIC_VECTOR (Size-1 downto 0);
           IN_v : in STD_LOGIC_VECTOR (Size-1 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_v : out STD_LOGIC_VECTOR (Size-1 downto 0));
end Banc_Memoire_Donnnees;

architecture Behavioral of Banc_Memoire_Donnnees is

    type Mem is ARRAY(0 to 16) of std_logic_vector( Size-1 downto 0);
    signal ram: Mem := (others => (others =>'0'));
    
begin

   BM:  process (CLK) is 
        begin
            if rising_edge(CLK) then 
                    if RST='0'then 
                        ram<= (others => (others =>'0'));
            else
                    if RW='1' then   --lecture
                        OUT_v <= ram(TO_INTEGER(unsigned (Addr)));
                     else 
                        ram(TO_INTEGER(unsigned(Addr)))<= IN_v;
                      end if;
                     end if;
            end if;
         end process;           
                
 

end Behavioral;
