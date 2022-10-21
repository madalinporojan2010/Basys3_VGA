----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 08:13:19 PM
-- Design Name: 
-- Module Name: counters - Behavioral
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

ENTITY Counters IS
    GENERIC (
        HORIZONTAL : INTEGER;
        VERTICAL   : INTEGER);
    PORT (
        clk       : IN  STD_LOGIC;
        rst       : IN  STD_LOGIC;
        H_counter : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
        V_counter : OUT STD_LOGIC_VECTOR (9 DOWNTO 0));
END Counters;

ARCHITECTURE Behavioral OF Counters IS

    SIGNAL Q1_value : INTEGER   := 0;
    SIGNAL Q2_value : INTEGER   := 0;

    SIGNAL TC       : STD_LOGIC := '0';
    SIGNAL EN       : STD_LOGIC := '0';
BEGIN

    --horizontal counter up to 799
    horizontal_counter : PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            Q1_value <= 0;
            TC       <= '0';
        ELSIF rising_edge(clk) THEN
            Q1_value <= Q1_value + 1;
            IF Q1_value = HORIZONTAL THEN
                Q1_value <= 0;
                TC       <= '1';
            ELSE
                TC <= '0';
            END IF;
        END IF;
    END PROCESS;

    --vertical counter up to 524
    EN <= TC;
    vertical_counter : PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            Q2_value <= 0;
        ELSIF rising_edge(clk) THEN
            IF EN = '1' THEN
                Q2_value <= Q2_value + 1;
                IF Q2_value = VERTICAL THEN
                    Q2_value <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    H_counter <= STD_LOGIC_VECTOR(to_unsigned(Q1_value, H_counter'length));
    V_counter <= STD_LOGIC_VECTOR(to_unsigned(Q2_value, V_counter'length));

END Behavioral;