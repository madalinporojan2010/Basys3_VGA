----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 06:46:38 PM
-- Design Name: 
-- Module Name: Frequency_Divider - Behavioral
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
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Frequency_Divider is
    Port ( clk : in STD_LOGIC;
           clk_25Mhz : out STD_LOGIC);
end Frequency_Divider;

architecture Behavioral of Frequency_Divider is
signal Q1: STD_LOGIC := '0';
signal Q2: STD_LOGIC := '0';

signal D1: STD_LOGIC := '0';
signal D2: STD_LOGIC := '0';

signal clk_50Mhz_not: STD_LOGIC := '0';
begin
    -- Bistabile D
    -- Avem nevoie de 2 bistabile D, deoarece e necesar un semnal de 25 Mhz => 100 Mhz / 2 / 2 => 25 Mhz
   
    D1 <= not Q1;
    D2 <= not Q2;
    
    D_1: process(clk) is
    begin
        if rising_edge(clk) then
            Q1 <= D1;
        end if;
    end process;
    
    D_2: process(clk_50Mhz_not) is
    begin
        if rising_edge(clk_50Mhz_not) then
            Q2 <= D2;
        end if;
    end process;
    
    clk_25Mhz <= Q2;
    clk_50Mhz_not <= not Q1;
end Behavioral;
