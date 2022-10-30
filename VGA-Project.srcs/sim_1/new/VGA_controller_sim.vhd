----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2022 10:45:46 PM
-- Design Name: 
-- Module Name: VGA_controller_sim - Behavioral
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
USE IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY VGA_controller_sim IS
    --  Port ( );
END VGA_controller_sim;

ARCHITECTURE Behavioral OF VGA_controller_sim IS
    CONSTANT HORIZONTAL             : INTEGER := 800;
    CONSTANT VERTICAL               : INTEGER := 525;

    CONSTANT H_MIN_HS_VS_GENERATION : INTEGER := 0;
    CONSTANT H_MAX_HS_VS_GENERATION : INTEGER := 96;

    CONSTANT V_MIN_HS_VS_GENERATION : INTEGER := 0;
    CONSTANT V_MAX_HS_VS_GENERATION : INTEGER := 2;

    COMPONENT VGA_Controller IS
        PORT (
            clk   : IN  STD_LOGIC;
            rst   : IN  STD_LOGIC;

            inc   : IN  STD_LOGIC;
            dec   : IN  STD_LOGIC;

            RED   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            GREEN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            BLUE  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

            HS    : OUT STD_LOGIC;
            VS    : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT clk_period : TIME                         := 10 ns;

    SIGNAL clk          : STD_LOGIC                    := '0';
    SIGNAL rst          : STD_LOGIC                    := '0';

    SIGNAL inc          : STD_LOGIC                    := '0';
    SIGNAL dec          : STD_LOGIC                    := '0';

    SIGNAL RED          : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"0";
    SIGNAL GREEN        : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"0";
    SIGNAL BLUE         : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"0";

    SIGNAL HS           : STD_LOGIC                    := '0';
    SIGNAL VS           : STD_LOGIC                    := '0';
BEGIN
    gen_clk : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR (clk_period / 2);
        clk <= '1';
        WAIT FOR (clk_period / 2);
    END PROCESS gen_clk;

    DUT : VGA_Controller
    PORT MAP(
        clk   => clk,
        rst   => rst,

        inc   => inc,
        dec   => dec,

        RED   => RED,
        GREEN => GREEN,
        BLUE  => BLUE,

        HS    => HS,
        VS    => VS
    );

    verify_func : PROCESS
        VARIABLE HCounter : INTEGER RANGE 0 TO HORIZONTAL := 0;
        VARIABLE VCounter : INTEGER RANGE 0 TO VERTICAL   := 0;
        VARIABLE NrErori  : INTEGER                       := 0;
    BEGIN
        Rst <= '1';
        WAIT FOR clk_period * 4;
        Rst <= '0';
        FOR i IN 0 TO VERTICAL - 1 LOOP
            FOR j IN 0 TO HORIZONTAL - 1 LOOP

                IF HCounter >= H_MIN_HS_VS_GENERATION AND HCounter < H_MAX_HS_VS_GENERATION AND HS /= '1' THEN
                    REPORT "EXPECTED HS(1) READ HS(" &
                        STD_LOGIC'image(HS) &
                        ") la t = " & TIME'image (now)
                        SEVERITY ERROR;
                    NrErori := NrErori + 1;
                END IF;

                IF VCounter >= V_MIN_HS_VS_GENERATION AND VCounter < V_MAX_HS_VS_GENERATION AND VS /= '1' THEN
                    REPORT "EXPECTED VS(1) READ VS(" &
                        STD_LOGIC'image(VS) &
                        ") la t = " & TIME'image (now)
                        SEVERITY ERROR;
                    NrErori := NrErori + 1;
                END IF;

                IF HCounter < H_MIN_HS_VS_GENERATION AND HS /= '0' THEN
                    REPORT "EXPECTED HS(0) READ HS(" &
                        STD_LOGIC'image(HS) &
                        ") la t = " & TIME'image (now)
                        SEVERITY ERROR;
                    NrErori := NrErori + 1;
                END IF;

                IF VCounter < V_MIN_HS_VS_GENERATION AND VS /= '0' THEN
                    REPORT "EXPECTED VS(0) READ VS(" &
                        STD_LOGIC'image(VS) &
                        ") la t = " & TIME'image (now)
                        SEVERITY ERROR;
                    NrErori := NrErori + 1;
                END IF;

                WAIT FOR clk_period * 4;
                HCounter := HCounter + 1;
                IF HCounter = HORIZONTAL THEN
                    HCounter := 0;
                END IF;
            END LOOP;
            WAIT FOR clk_period * 4;
            VCounter := VCounter + 1;
            IF VCounter = VERTICAL THEN
                VCounter := 0;
            END IF;
        END LOOP;
        REPORT "Testare terminata cu " &
            INTEGER'image (NrErori) & " erori";
        WAIT;
    END PROCESS verify_func;

END Behavioral;