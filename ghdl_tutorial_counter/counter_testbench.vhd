library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 

--top level entry has no inputs
entity counter_testbench is
end counter_testbench; 

architecture behavior of counter_testbench is
    component counter is
        port (
            count: out std_logic_vector(7 downto 0); 
            reset: in std_logic; 
            clk: in std_logic
        ); 
    end component;
    signal count_tb: std_logic_vector(7 downto 0); --register holding result of couner
    signal reset_tb: std_logic; 
    signal clk_tb: std_logic; 
    
    constant clock_period : time := 20 us;

    begin
        DUT: counter port map(
            count => count_tb,
            reset => reset_tb,
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

        --process to simulate counter
        sim_proc: process begin
            ---start with reset low
            reset_tb <= '0'; 
            wait for 100 ns; 
            
            reset_tb <= '1'; 
            wait for 100 ns;
        end process; 
end architecture; 
            
