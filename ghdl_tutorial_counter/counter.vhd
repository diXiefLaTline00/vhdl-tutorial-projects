library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 

entity counter is
    port (
        count: out std_logic_vector(7 downto 0); 
        reset: in std_logic; 
        clk: in std_logic
    );
end counter;

architecture logic of counter is
    signal tmp: std_logic_vector(7 downto 0); 
    begin
        process (clk) begin
            if (reset='0') then
                tmp <= (others => '0'); 
            elsif (rising_edge(clk)) then
                tmp <= tmp + 1; 
            end if; 
        end process; 
    count <= tmp; 
end logic; 