LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 

ENTITY counterNbit IS
    PORT (
        clk : IN std_logic;
        rst : IN std_logic;
        counter : OUT std_logic_vector(7 DOWNTO 0)
    );
END counterNbit;

ARCHITECTURE rtl OF counterNbit IS
    SIGNAL cntr_reg : std_logic_vector(7 DOWNTO 0);

BEGIN
    cntr_PROC : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            cntr_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            cntr_reg <= cntr_reg + '1';
        END IF;
    END PROCESS;

    counter <= cntr_reg;

END ARCHITECTURE;