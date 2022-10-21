-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGA_Controller is
  Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    RED : out STD_LOGIC_VECTOR ( 3 downto 0 );
    GREEN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BLUE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    HS : out STD_LOGIC;
    VS : out STD_LOGIC
  );

end VGA_Controller;

architecture stub of VGA_Controller is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
begin
end;
