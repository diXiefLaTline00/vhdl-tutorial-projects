library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity de0adccntrl_tb is
end de0adccntrl_tb ; 

architecture arch of de0adccntrl_tb is
    signal i_clk:   std_logic := '0'; 
    signal i_reset:   std_logic; 
    signal i_enbl:   std_logic; 
    signal i_adc_chan:   std_logic_vector(2 downto 0); 
    signal adc_conversion:   std_logic_vector(11 downto 0);
    signal o_adc_conv_result: std_logic; 

    --adc signal lines
    signal adc_sclk:   std_logic; 
    signal adc_enable:   std_logic; 
    signal adc_mosi:   std_logic;
    signal adc_miso:   std_logic; 
    
begin
     -- Device under test
     DUT : entity work.de0adccntrl(rtl)
     port map (
        i_clk => i_clk,
        i_reset => i_reset, 
        i_enbl => i_enbl,
        i_adc_chan => i_adc_chan, 
        adc_conversion => adc_conversion, 
        adc_sclk => adc_sclk,
        adc_enable => adc_enable, 
        adc_mosi => adc_mosi,
        adc_miso => adc_miso,
        o_adc_conv_result => o_adc_conv_result
     );
     
     CLK_PROC : process
     begin
         i_clk <= not i_clk; 
         wait for 10 ns;
     end process ; -- CLK_PROC

     RESET_PROC : process
     begin
        i_reset <= '1'; 
         wait for 2 ns; 
         i_reset <= '0'; 
         wait for 10 ns; 
         i_reset <= '1'; 
         wait; 
     end process ; -- RESET_PROC

     INIT : process
     begin
        i_adc_chan <= "101"; 
        wait for 5 us; 
        i_enbl <= '1';
        wait; 
     end process ; -- INIT

     MISO : process
     begin
        adc_miso <= '1'; 
        wait; 
     end process ; -- MISO

     

end architecture; 