library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

--button debouncer does not need a fast clock
--high level instantiation
entity button_debouncer is
    port(
        pulse: out std_logic; 
        clk, button: in std_logic
    ); 
end button_debouncer; 

--architecture definition
architecture logic of button_debouncer is
    signal count: std_logic_vector(9 downto 0); 
    begin
        ---increment counter if button is pressed
        process (clk) begin
            if (button='0') then
                count <= (others => '0');
                pulse <= '0'; 
            elsif (count(8) = '1') then
                pulse <= '1'; 
                count <= (others => '0'); 
            elsif (rising_edge(clk)) then
                count <= count + 1;
            end if; 
        end process;
end architecture; 
    

