library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
-- use std.env.finish;

entity km2filter_tb is
end km2filter_tb;

architecture sim of km2filter_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';

    signal x, y: std_logic_vector(15 downto 0); 
    signal input_signal : std_logic_vector(15 downto 0);
    signal output_ready : std_logic; 
    file input_file : TEXT open READ_MODE is "testbench_input.txt";

begin

    clk <= not clk after clk_period / 2;
    rst     <= '1', '1' after 100 ns, '0' after 503 ns; 

    DUT : entity work.km2filter(rtl)
    generic map (
        data_width => 16
    )
    port map (
        clk => clk,
        rst => rst,
        x => input_signal,
        y => y
    );


    DATAREADER_PROC : process(clk,rst)
    variable input_line : LINE; 
    variable raw_input_integer: integer;  
    begin
        if (rst='1') then
            input_signal <= (others => '0');
            output_ready <= '0';  
        elsif rising_edge(clk) then
            readline(input_file,input_line); 
            read(input_line,raw_input_integer); 
            input_signal <= std_logic_vector(to_signed(raw_input_integer,16)); 
            output_ready <= '1'; 
            --report raw_input_integer; --prints to standard output 
        end if ;
    end process;

end architecture;