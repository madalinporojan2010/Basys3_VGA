LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mpg IS
    PORT (
        Clk    : IN  STD_LOGIC;
        Btn    : IN  STD_LOGIC;
        Enable : OUT STD_LOGIC);
END mpg;

ARCHITECTURE Behavioral OF mpg IS
    SIGNAL Count : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Q1    : STD_LOGIC                     := '0';
    SIGNAL Q2    : STD_LOGIC                     := '0';
    SIGNAL Q3    : STD_LOGIC                     := '0';
BEGIN
    counter : PROCESS (Clk)
    BEGIN
        IF RISING_EDGE (Clk) THEN
            Count <= Count + 1;
        END IF;
    END PROCESS counter;

    Q1 <= Btn WHEN RISING_EDGE (Clk) AND Count = x"FFFF" ELSE
          Q1;
    Q2 <= Q1 WHEN RISING_EDGE (Clk) ELSE
          Q2;
    Q3 <= Q2 WHEN RISING_EDGE (Clk) ELSE
          Q3;

    Enable <= Q2 AND (NOT Q3);

END Behavioral;