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

entity VGA_Controller is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        
        RED : out STD_LOGIC_VECTOR (3 downto 0);
        GREEN : out STD_LOGIC_VECTOR (3 downto 0);
        BLUE : out STD_LOGIC_VECTOR (3 downto 0);
        
        HS : out STD_LOGIC;
        VS : out STD_LOGIC
    );
end VGA_Controller;

architecture Behavioral of VGA_Controller is
constant HORIZONTAL : INTEGER := 800;
constant VERTICAL : INTEGER := 525;

constant HEIGHT : INTEGER := 240;
constant WIDTH : INTEGER := 320;

constant H_MIN_ADDRESSABLE : INTEGER := 144;
constant H_MAX_ADDRESSABLE : INTEGER := 784;

constant V_MIN_ADDRESSABLE : INTEGER := 35;
constant V_MAX_ADDRESSABLE : INTEGER := 515;

constant H_MIN_HS_VS_GENERATION : INTEGER := 0;
constant H_MAX_HS_VS_GENERATION : INTEGER := 96;

constant V_MIN_HS_VS_GENERATION : INTEGER := 0;
constant V_MAX_HS_VS_GENERATION : INTEGER := 2;

signal clk_25Mhz : STD_LOGIC := '0';
signal H_counter : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal V_counter : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

signal Display_Area : STD_LOGIC := '0';

signal RED_temp : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal GREEN_temp : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal BLUE_temp : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

signal Img_data : std_logic_vector (11 downto 0) := (others => '0');
signal memAddr : std_logic_vector (16 downto 0) := (others => '0');

COMPONENT BRAM_img1
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) 
  );
END COMPONENT;

begin
    freq_div : entity work.Frequency_Divider(Behavioral)
               port map(
                clk => clk,
                clk_25Mhz => clk_25Mhz
               );

    cnts : entity work.Counters(Behavioral)
           generic map(
            HORIZONTAL => HORIZONTAL,
            VERTICAL => VERTICAL
           )
           port map(
            clk => clk_25Mhz,
            rst => rst,
            H_counter => H_counter,
            V_counter => V_counter
           );
    
    comp : entity work.Comparators(Behavioral)
           generic map(
                H_MIN_ADDRESSABLE => H_MIN_ADDRESSABLE,
                H_MAX_ADDRESSABLE => H_MAX_ADDRESSABLE,
                V_MIN_ADDRESSABLE => V_MIN_ADDRESSABLE,
                V_MAX_ADDRESSABLE => V_MAX_ADDRESSABLE,
                H_MIN_HS_VS_GENERATION => H_MIN_HS_VS_GENERATION,
                H_MAX_HS_VS_GENERATION => H_MAX_HS_VS_GENERATION,
                V_MIN_HS_VS_GENERATION => V_MIN_HS_VS_GENERATION,
                V_MAX_HS_VS_GENERATION => V_MAX_HS_VS_GENERATION
           )
           port map(
                H_counter => H_counter,
                V_counter => V_counter,
                HS => HS,
                VS => VS,
                Display_Area => Display_Area
           );
           
--     mem : entity work.Img_Memory(Behavioral)
--           generic map (
--                RAM_HEIGHT => HEIGHT,
--                RAM_WIDTH => WIDTH
--           )
--           port map (
--                H_counter => H_counter,
--                V_counter => V_counter,
--                data => Img_Data
--           );

     memAddr <= std_logic_vector(to_unsigned((to_integer(unsigned(V_counter)) - 35) * (to_integer(unsigned(H_Counter)) - 144), memAddr'length)) 
                when Display_Area = '1' and (to_integer(unsigned(V_counter)) - 35) < 240 and (to_integer(unsigned(H_Counter)) - 144) < 320 else
                "00000000000000000"
                ;
     your_instance_name : BRAM_img1
          PORT MAP (
            clka => clk_25Mhz,
            wea => "0",
            addra => memAddr,
            dina => x"000",
            douta => Img_data
          );
     
     color_mux: process(Display_Area) is
     begin
        if Display_Area = '1' and (to_integer(unsigned(V_counter)) - 35) < 240 and (to_integer(unsigned(H_Counter)) - 144) < 320 then
            RED_temp <= Img_data(11 downto 8);
            GREEN_temp <= Img_data(7 downto 4);
            BLUE_temp <= Img_data(3 downto 0);
        else
            RED_temp <= x"0";
            GREEN_temp <= x"0";
            BLUE_temp <= x"0";
        end if;
     end process;

    RED <= RED_temp;
    GREEN <= GREEN_temp;
    BLUE <= BLUE_temp;
end Behavioral;
