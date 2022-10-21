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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Frequency_Divider IS
    PORT (
        clk       : IN  STD_LOGIC;
        clk_25Mhz : OUT STD_LOGIC);
END Frequency_Divider;

ARCHITECTURE Behavioral OF Frequency_Divider IS
    SIGNAL Q1            : STD_LOGIC := '0';
    SIGNAL Q2            : STD_LOGIC := '0';

    SIGNAL D1            : STD_LOGIC := '0';
    SIGNAL D2            : STD_LOGIC := '0';

    SIGNAL clk_50Mhz_not : STD_LOGIC := '0';
BEGIN
    -- Bistabile D
    -- Avem nevoie de 2 bistabile D, deoarece e necesar un semnal de 25 Mhz => 100 Mhz / 2 / 2 => 25 Mhz

    D1 <= NOT Q1;
    D2 <= NOT Q2;

    D_1 : PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            Q1 <= D1;
        END IF;
    END PROCESS;

    D_2 : PROCESS (clk_50Mhz_not) IS
    BEGIN
        IF rising_edge(clk_50Mhz_not) THEN
            Q2 <= D2;
        END IF;
    END PROCESS;

    clk_25Mhz     <= Q2;
    clk_50Mhz_not <= NOT Q1;
END Behavioral;