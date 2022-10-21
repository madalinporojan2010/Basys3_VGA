----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 08:32:52 PM
-- Design Name: 
-- Module Name: VGA_Constants - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Constants is
    generic (    
        constant HORIZONTAL : INTEGER := 800;
        constant VERTICAL : INTEGER := 525;
        
        constant H_MIN_ADDRESSABLE : INTEGER := 144;
        constant H_MAX_ADDRESSABLE : INTEGER := 784;
        
        constant V_MIN_ADDRESSABLE : INTEGER := 35;
        constant V_MAX_ADDRESSABLE : INTEGER := 515
    );
end VGA_Constants;

architecture Behavioral of VGA_Constants is
begin


end Behavioral;
