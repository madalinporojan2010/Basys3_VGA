------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 10/14/2022 11:19:41 PM
---- Design Name: 
---- Module Name: Img_Memory - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use std.textio.all;
---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity Img_Memory is
--    generic(
--        RAM_HEIGHT: INTEGER:=240;
--        RAM_WIDTH: INTEGER:=320
--    );
--     Port (
--        H_counter: in std_logic_vector(9 downto 0);
--        V_counter: in std_logic_vector(9 downto 0);
--        data: out std_logic_vector(11 downto 0)
--     );
--end Img_Memory;

--architecture Behavioral of Img_Memory is
--    type ram_type is array (0 to RAM_HEIGHT - 1, 0 to RAM_WIDTH - 1) of std_logic_vector(11 downto 0);
   
--    function initramfromfile (ramfilename : in string) return ram_type is
--    file ramfile	: text open read_mode is ramfilename;
--    variable ramfileline : line;
--    variable ram_name	: ram_type;
--    variable element : bit_vector(7 downto 0);
--    variable end_of_line : boolean:=false;
--    variable row : integer := 0;
--    variable col : integer := 0;
--    begin
--        --for i in 0 to RAM_HEIGHT - 1 loop
--            --readline (ramfile, ramfileline);
--            --for j in 0 to RAM_WIDTH - 1 loop
--                --read (ramfileline, element);
--              --  ram_name(i, j) := std_logic_vector(to_unsigned(element, ram_name(i, j)'length));
--            --end loop;
            
--            while(not endfile(ramfile))loop
      
--                readline(ramfile, ramfileline);
--                read(ramfileline, element, end_of_line); 
--                while(end_of_line)loop     
--                   ram_name(col,row):= To_StdLogicVector (element);
--                   read(ramfileline, element, end_of_line); 
--                   row := row + 1;
--                end loop;
--                col := col + 1;
--                end_of_line := true;
--             end loop;
--        --end loop;
--        return ram_name;
--    end function;
    
--    function init_from_file_or_zeroes(ramfile : string) return ram_type is
--    begin
--        if ramfile = "C:\Users\Madalin\OneDrive\SSC\img_src\converted\img1.mem" then
--            return InitRamFromFile("C:\Users\Madalin\OneDrive\SSC\img_src\converted\img1.mem") ;
--        else
--            return (others => (others =>(others=> '0')));
--        end if;
--    end;
    
    
--    signal img : ram_type := init_from_file_or_zeroes("C:\Users\Madalin\OneDrive\SSC\img_src\converted\img1.mem");
    
--begin
--    data <= img(to_integer(unsigned(V_counter)) - 35, to_integer(unsigned(H_counter)) - 144) when (to_integer(unsigned(H_counter)) < 320 + 144) and (to_integer(unsigned(V_counter)) < 240 + 35);
--end Behavioral;
