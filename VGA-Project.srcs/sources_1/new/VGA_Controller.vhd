----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 08:46:29 PM
-- Design Name: 
-- Module Name: VGA_Controller - Behavioral
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

ENTITY VGA_Controller IS
    PORT (
        clk   : IN  STD_LOGIC;
        rst   : IN  STD_LOGIC;

        RED   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        GREEN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        BLUE  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

        HS    : OUT STD_LOGIC;
        VS    : OUT STD_LOGIC;

        sw    : IN  STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END VGA_Controller;

ARCHITECTURE Behavioral OF VGA_Controller IS
    CONSTANT HORIZONTAL             : INTEGER                        := 800;
    CONSTANT VERTICAL               : INTEGER                        := 525;

    CONSTANT HEIGHT                 : INTEGER                        := 480;
    CONSTANT WIDTH                  : INTEGER                        := 640;

    CONSTANT H_MIN_ADDRESSABLE      : INTEGER                        := 144;
    CONSTANT H_MAX_ADDRESSABLE      : INTEGER                        := 784;

    CONSTANT V_MIN_ADDRESSABLE      : INTEGER                        := 35;
    CONSTANT V_MAX_ADDRESSABLE      : INTEGER                        := 515;

    CONSTANT H_MIN_HS_VS_GENERATION : INTEGER                        := 0;
    CONSTANT H_MAX_HS_VS_GENERATION : INTEGER                        := 96;

    CONSTANT V_MIN_HS_VS_GENERATION : INTEGER                        := 0;
    CONSTANT V_MAX_HS_VS_GENERATION : INTEGER                        := 2;

    SIGNAL clk_25Mhz                : STD_LOGIC                      := '0';
    SIGNAL H_counter                : STD_LOGIC_VECTOR (9 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL V_counter                : STD_LOGIC_VECTOR (9 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL H_counter_addressable    : INTEGER                        := 0;
    SIGNAL V_counter_addressable    : INTEGER                        := 0;
    SIGNAL H_V_index                : INTEGER                        := 0;

    SIGNAL Display_Area             : STD_LOGIC                      := '0';

    SIGNAL RED_temp                 : STD_LOGIC_VECTOR (3 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL GREEN_temp               : STD_LOGIC_VECTOR (3 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL BLUE_temp                : STD_LOGIC_VECTOR (3 DOWNTO 0)  := (OTHERS => '0');

    SIGNAL Img_data                 : STD_LOGIC_VECTOR (4 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL memAddr                  : STD_LOGIC_VECTOR (18 DOWNTO 0) := (OTHERS => '0');

    COMPONENT BRAM_img1
        PORT (
            clka  : IN  STD_LOGIC;
            wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN  STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    freq_div : ENTITY work.Frequency_Divider(Behavioral)
        PORT MAP(
            clk       => clk,
            clk_25Mhz => clk_25Mhz
        );

    cnts : ENTITY work.Counters(Behavioral)
        GENERIC MAP(
            HORIZONTAL => HORIZONTAL,
            VERTICAL   => VERTICAL
        )
        PORT MAP(
            clk       => clk_25Mhz,
            rst       => rst,
            H_counter => H_counter,
            V_counter => V_counter
        );

    comp : ENTITY work.Comparators(Behavioral)
        GENERIC MAP(
            H_MIN_ADDRESSABLE      => H_MIN_ADDRESSABLE,
            H_MAX_ADDRESSABLE      => H_MAX_ADDRESSABLE,
            V_MIN_ADDRESSABLE      => V_MIN_ADDRESSABLE,
            V_MAX_ADDRESSABLE      => V_MAX_ADDRESSABLE,
            H_MIN_HS_VS_GENERATION => H_MIN_HS_VS_GENERATION,
            H_MAX_HS_VS_GENERATION => H_MAX_HS_VS_GENERATION,
            V_MIN_HS_VS_GENERATION => V_MIN_HS_VS_GENERATION,
            V_MAX_HS_VS_GENERATION => V_MAX_HS_VS_GENERATION
        )
        PORT MAP(
            H_counter    => H_counter,
            V_counter    => V_counter,
            HS           => HS,
            VS           => VS,
            Display_Area => Display_Area
        );

    H_counter_addressable <= to_integer(unsigned(H_counter)) - H_MIN_ADDRESSABLE;
    V_counter_addressable <= to_integer(unsigned(V_counter)) - V_MIN_ADDRESSABLE;
    H_V_index             <= V_counter_addressable * WIDTH + H_counter_addressable;

    memAddr               <= STD_LOGIC_VECTOR(to_unsigned(H_V_index, memAddr'length))
               WHEN Display_Area = '1' AND (V_counter_addressable < HEIGHT) AND (H_counter_addressable < WIDTH) AND (V_counter_addressable >= 0) AND (H_counter_addressable >= 0) ELSE
               "1111111111111111111";
    img_mem : BRAM_img1
    PORT MAP(
        clka  => clk_25Mhz,
        wea   => "0",
        addra => memAddr,
        dina  => "00000",
        douta => Img_data
    );

    color_mux : PROCESS (Display_Area, V_counter_addressable, H_counter_addressable, Img_Data, sw) IS
    BEGIN
        IF Display_Area = '1' AND (V_counter_addressable < HEIGHT) AND (H_counter_addressable < WIDTH) AND (V_counter_addressable >= 0) AND (H_counter_addressable >= 0) THEN
            IF sw(0 DOWNTO 0) = "1" THEN
                IF Img_Data(0 DOWNTO 0) = "1" THEN
                    RED_temp   <= x"F";
                    GREEN_temp <= x"F";
                    BLUE_temp  <= x"F";
                ELSE
                    RED_temp   <= x"0";
                    GREEN_temp <= x"0";
                    BLUE_temp  <= x"0";
                END IF;
            ELSIF sw(1 DOWNTO 1) = "1" THEN
                IF Img_Data(1 DOWNTO 1) = "1" THEN
                    RED_temp   <= x"F";
                    GREEN_temp <= x"F";
                    BLUE_temp  <= x"F";
                ELSE
                    RED_temp   <= x"0";
                    GREEN_temp <= x"0";
                    BLUE_temp  <= x"0";
                END IF;
            ELSIF sw(2 DOWNTO 2) = "1" THEN
                IF Img_Data(2 DOWNTO 2) = "1" THEN
                    RED_temp   <= x"F";
                    GREEN_temp <= x"F";
                    BLUE_temp  <= x"F";
                ELSE
                    RED_temp   <= x"0";
                    GREEN_temp <= x"0";
                    BLUE_temp  <= x"0";
                END IF;
            ELSIF sw(3 DOWNTO 3) = "1" THEN
                IF Img_Data(3 DOWNTO 3) = "1" THEN
                    RED_temp   <= x"F";
                    GREEN_temp <= x"F";
                    BLUE_temp  <= x"F";
                ELSE
                    RED_temp   <= x"0";
                    GREEN_temp <= x"0";
                    BLUE_temp  <= x"0";
                END IF;
            ELSE
                IF Img_Data(4 DOWNTO 4) = "1" THEN
                    RED_temp   <= x"F";
                    GREEN_temp <= x"F";
                    BLUE_temp  <= x"F";
                ELSE
                    RED_temp   <= x"0";
                    GREEN_temp <= x"0";
                    BLUE_temp  <= x"0";
                END IF;
            END IF;
        ELSIF Display_Area = '1' THEN
            RED_temp   <= x"F";
            GREEN_temp <= x"F";
            BLUE_temp  <= x"F";
        ELSE
            RED_temp   <= x"0";
            GREEN_temp <= x"0";
            BLUE_temp  <= x"0";
        END IF;
    END PROCESS;

    RED   <= RED_temp;
    GREEN <= GREEN_temp;
    BLUE  <= BLUE_temp;
END Behavioral;