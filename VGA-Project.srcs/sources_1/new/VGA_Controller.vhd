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

ENTITY VGA_Controller IS
    PORT (
        clk   : IN  STD_LOGIC;
        rst   : IN  STD_LOGIC;

        RED   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        GREEN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        BLUE  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

        HS    : OUT STD_LOGIC;
        VS    : OUT STD_LOGIC
    );
END VGA_Controller;

ARCHITECTURE Behavioral OF VGA_Controller IS
    CONSTANT HORIZONTAL             : INTEGER                        := 800;
    CONSTANT VERTICAL               : INTEGER                        := 525;

    CONSTANT HEIGHT                 : INTEGER                        := 240;
    CONSTANT WIDTH                  : INTEGER                        := 320;

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

    SIGNAL Img_data                 : STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memAddr                  : STD_LOGIC_VECTOR (16 DOWNTO 0) := (OTHERS => '0');

    COMPONENT BRAM_img1
        PORT (
            clka  : IN  STD_LOGIC;
            wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
            dina  : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
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
               "11111111111111111";
    img_mem : BRAM_img1
    PORT MAP(
        clka  => clk_25Mhz,
        wea   => "0",
        addra => memAddr,
        dina  => x"000",
        douta => Img_data
    );

    color_mux : PROCESS (Display_Area) IS
    BEGIN
        IF Display_Area = '1' AND (V_counter_addressable < HEIGHT) AND (H_counter_addressable < WIDTH) AND (V_counter_addressable >= 0) AND (H_counter_addressable >= 0) THEN
            RED_temp   <= Img_data(11 DOWNTO 8);
            GREEN_temp <= Img_data(7 DOWNTO 4);
            BLUE_temp  <= Img_data(3 DOWNTO 0);
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