library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 

entity button_debouncer_testbench is
end button_debouncer_testbench; 

architecture behavioural of button_debouncer_testbench is
    --define test signals
    component button_debouncer is
        port(
            pulse: out std_logic; 
            clk, button: in std_logic
        );
    end component; 

    signal pulse_tb: std_logic; 
    signal button_tb: std_logic; 
    signal clk_tb: std_logic; 
    constant clock_period : time := 40 us; 
    
    begin

        DUT: button_debouncer port map(
            pulse => pulse_tb,
            button => button_tb,
            clk => clk_tb
        );
        
        --clock process
        clock_process: process
        begin
            clk_tb <= '0'; 
            wait for clock_period/2; 
            clk_tb <= '1'; 
            wait for clock_period/2;
        end process; 

        sim_proc: process begin
            
            --simulate bouncing switch
            button_tb <= '0'; 
            wait for 5 ms; 
            button_tb <= '1'; 
            wait for 1 ms; 
            button_tb <= '0'; 
            wait for 1 ms; 
            button_tb <= '1'; 
            wait for 1 ms; 
            button_tb <= '0';
            button_tb <= '1'; 
            wait for 1 ms; 
            button_tb <= '0';
            wait for 5 ms; 


            ---long button press
            button_tb <= '1'; 
            wait for 20 ms;
            button_tb <= '0'; 

        end process; 
end architecture; 