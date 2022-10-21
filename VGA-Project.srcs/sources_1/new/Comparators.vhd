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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Comparators IS
    GENERIC (
        H_MIN_ADDRESSABLE      : INTEGER;
        H_MAX_ADDRESSABLE      : INTEGER;

        V_MIN_ADDRESSABLE      : INTEGER;
        V_MAX_ADDRESSABLE      : INTEGER;

        H_MIN_HS_VS_GENERATION : INTEGER;
        H_MAX_HS_VS_GENERATION : INTEGER;

        V_MIN_HS_VS_GENERATION : INTEGER;
        V_MAX_HS_VS_GENERATION : INTEGER
    );
    PORT (
        H_counter    : IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
        V_counter    : IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
        HS           : OUT STD_LOGIC;
        VS           : OUT STD_LOGIC;
        Display_Area : OUT STD_LOGIC
    );
END Comparators;

ARCHITECTURE Behavioral OF Comparators IS
    SIGNAL H_counter_integer : INTEGER := 0;
    SIGNAL V_counter_integer : INTEGER := 0;
BEGIN
    H_counter_integer <= to_integer(unsigned(H_counter));
    V_counter_integer <= to_integer(unsigned(V_counter));

    -- IS Horizontal Sync time?
    HS                <= '1' WHEN
          (H_counter_integer >= H_MIN_HS_VS_GENERATION) AND
          (H_counter_integer < H_MAX_HS_VS_GENERATION)
          ELSE
          '0';

    -- IS Display Area time?
    Display_Area <= '1' WHEN
                    (H_counter_integer >= H_MIN_ADDRESSABLE) AND
                    (H_counter_integer < H_MAX_ADDRESSABLE) AND
                    (V_counter_integer >= V_MIN_ADDRESSABLE) AND
                    (V_counter_integer < V_MAX_ADDRESSABLE)
                    ELSE
                    '0';

    -- IS Vertical Sync time?
    VS <= '1' WHEN
          (V_counter_integer >= V_MIN_HS_VS_GENERATION) AND
          (V_counter_integer < V_MAX_HS_VS_GENERATION)
          ELSE
          '0';

END Behavioral;