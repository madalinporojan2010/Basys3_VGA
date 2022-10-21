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

entity Counters is
    generic (    
        HORIZONTAL : INTEGER;
        VERTICAL : INTEGER);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           H_counter : out STD_LOGIC_VECTOR (9 downto 0);
           V_counter : out STD_LOGIC_VECTOR (9 downto 0));
end Counters;

architecture Behavioral of Counters is

signal Q1_value : INTEGER := 0;
signal Q2_value : INTEGER := 0;

signal TC : std_logic := '0';
signal EN : std_logic := '0';
begin

    --horizontal counter up to 799
    horizontal_counter: process(clk, rst) is
    begin
        if rst = '1' then
            Q1_value <= 0;
            TC <= '0';
        elsif rising_edge(clk) then
            Q1_value <= Q1_value + 1;
            if Q1_value = HORIZONTAL then
                Q1_value <= 0;
                TC <= '1';
            else
                TC <= '0';
            end if;
        end if;
    end process;
    
    --vertical counter up to 524
    EN <= TC;
    vertical_counter: process(clk, rst) is
    begin
        if rst = '1' then
            Q2_value <= 0;
        elsif rising_edge(clk) then
            if EN = '1' then
                Q2_value <= Q2_value + 1;
                if Q2_value = VERTICAL then
                    Q2_value <= 0;
                end if;
            end if;
        end if;
    end process;

    H_counter <= std_logic_vector(to_unsigned(Q1_value, H_counter'length));
    V_counter <= std_logic_vector(to_unsigned(Q2_value, V_counter'length));

end Behavioral;
