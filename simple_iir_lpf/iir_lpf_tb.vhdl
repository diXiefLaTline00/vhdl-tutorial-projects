--iir filtering test bench
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use std.textio.all; 

entity iir_lpf_tb is
end iir_lpf_tb; 

architecture logic of iir_lpf_tb is
    --variable definitions
    --define IIR filter

    component lpf_iir is
        generic (
            input_width : integer := 16; 
            scale: natural := 2
        ); 
        port (
            xn: in signed(input_width-1 downto 0); 
            yn: out signed(input_width-1 downto 0); 
            clk, reset : in std_logic
        ); 
    end component;

    signal xin : signed(16 - 1 downto 0); 
    signal yout: signed(16 -1 downto 0);
    signal clk:  std_logic := '0'; 
    signal reset: std_logic := '0'; 
    signal output_ready     :      std_logic:='0';                                
    file my_input : TEXT open READ_MODE is "input101.txt";  
    file my_output : TEXT open WRITE_MODE is "output101_functional_sim.txt";  
    

begin --it may look sequential but this is a text description of a bunch of concurrent processes
    DUT: lpf_iir
        generic map(
            input_width => 16,
            scale => 2             
        )
        port map (
            xn => xin,
            yn => yout,
            clk => clk,
            reset => reset
        ); 
    
        process(clk)
            begin
                clk <= not clk after 10 ns; 
        end process; 
    
        reset <= '1', '1' after 100 ns, '0' after 503 ns; 
        
        process(clk)  
            variable my_input_line : LINE;  
            variable input1: integer;  
            begin  
                if reset ='1' then  
                    xin <= (others=> '0');  
                    output_ready <= '0';  
                elsif rising_edge(clk) then                      
                    readline(my_input, my_input_line);  
                    read(my_input_line,input1);  
                    xin <= to_signed(input1, 16);
                    output_ready <= '1';  
                end if;  
            end process;

        process(clk)  
            variable my_output_line : LINE;  
            variable input1: integer;  
            begin  
                if falling_edge(clk) then  
                    if output_ready ='1' then  
                        write(my_output_line, to_integer(signed(yout)));  
                        writeline(my_output,my_output_line);  
                    end if;  
                end if;  
            end process; 
end logic ; -- logic