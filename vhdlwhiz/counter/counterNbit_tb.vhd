LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 

use std.textio.all;
--use std.env.finish;

entity counterNbit_tb is
end counterNbit_tb;

architecture sim of counterNbit_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';

    signal counter : std_logic_vector(7 downto 0);-- := "00000000"; 

begin

    DUT : entity work.counterNbit(rtl)
    port map (
        clk => clk,
        rst => rst,
        counter => counter
    );

    clk <= not clk after clk_period / 2;

    SEQUENCER_PROC : process
    begin
        wait for clk_period * 2;
        rst <= '0';
        wait for clk_period * 10;
    end process;

end architecture;