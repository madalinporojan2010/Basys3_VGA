----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 09:14:10 PM
-- Design Name: 
-- Module Name: Comparators - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Comparators is
    Generic (
        H_MIN_ADDRESSABLE : INTEGER;
        H_MAX_ADDRESSABLE : INTEGER;
        
        V_MIN_ADDRESSABLE : INTEGER;
        V_MAX_ADDRESSABLE : INTEGER;
        
        H_MIN_HS_VS_GENERATION : INTEGER;
        H_MAX_HS_VS_GENERATION : INTEGER;
        
        V_MIN_HS_VS_GENERATION : INTEGER;
        V_MAX_HS_VS_GENERATION : INTEGER
    );
    Port (
        H_counter : in std_logic_vector (9 downto 0);
        V_counter : in std_logic_vector (9 downto 0);
        HS : out std_logic;
        VS : out std_logic;
        Display_Area : out std_logic
    );
end Comparators;

architecture Behavioral of Comparators is
signal H_counter_integer : INTEGER := 0;
signal V_counter_integer : INTEGER := 0;
begin
    H_counter_integer <= to_integer(unsigned(H_counter));
    V_counter_integer <= to_integer(unsigned(V_counter));

    -- IS Horizontal Sync time?
    HS <= '1' when 
                (H_counter_integer >= H_MIN_HS_VS_GENERATION) and
                (H_counter_integer < H_MAX_HS_VS_GENERATION)
              else '0';
              
    -- IS Display Area time?
    Display_Area <= '1' when 
                (H_counter_integer >= H_MIN_ADDRESSABLE) and
                (H_counter_integer < H_MAX_ADDRESSABLE) and
                (V_counter_integer >= V_MIN_ADDRESSABLE) and
                (V_counter_integer < V_MAX_ADDRESSABLE)
              else '0';
    
    -- IS Vertical Sync time?
    VS <= '1' when 
                (V_counter_integer >= V_MIN_HS_VS_GENERATION) and
                (V_counter_integer < V_MAX_HS_VS_GENERATION)
              else '0';

end Behavioral;
