library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity de0adccntrl is
    generic (
        CLK_DIV: natural := 16
    ); 
  port (
    signal i_clk: in std_logic;
    signal i_reset: in std_logic; 
    signal i_enbl: in std_logic; 
    signal i_adc_chan: in std_logic_vector(2 downto 0);
    signal adc_conversion: out std_logic_vector(11 downto 0);
    signal o_adc_conv_result: out std_logic; --clock which indicates when a sample is ready

    --adc signal lines
    signal adc_sclk: out std_logic; 
    signal adc_enable: out std_logic; 
    signal adc_mosi: out std_logic;
    signal adc_miso: in std_logic
  ) ;
end de0adccntrl ;
architecture rtl of de0adccntrl is
    signal conversion_counter: natural range 0 to 15; 
    signal r_adc_chan: std_logic_vector(2 downto 0);
    signal r_enable: std_logic;
    signal r_adc_i: std_logic; 
    signal r_adc_conversion: std_logic_vector(11 downto 0); 
    
    --clock registers
    signal r_adc_clk: std_logic;
    signal r_adc_clk_rising_edge: std_logic; 
    signal r_adc_clk_falling_edge: std_logic;
    signal clk_cntr: natural range 0 to CLK_DIV := 0;
  
begin
    CLKDIV_PROC : process( i_clk,i_reset )
    begin
        if (i_reset = '0') then
            clk_cntr <= 0; 
            r_adc_clk <= '0'; 
            r_adc_clk_falling_edge <= '0'; 
            r_adc_clk_rising_edge <= '0';
            r_enable <= '0';
            adc_sclk <= '0'; 
        elsif rising_edge(i_clk) then
            if r_enable = '1' then
                if (clk_cntr = (CLK_DIV - 1)) then
                    clk_cntr <= 0; 
                    r_adc_clk <= not r_adc_clk; 
                    if r_adc_clk = '1' then
                        r_adc_clk_falling_edge <= '1';
                    else
                        r_adc_clk_rising_edge <= '1';  
                    end if; 
                else
                    clk_cntr <= clk_cntr + 1;
                    r_adc_clk_rising_edge <= '0';  
                    r_adc_clk_falling_edge <= '0';
                end if; 
            end if; 
            r_enable <= i_enbl; 
        end if; 
        adc_sclk <= r_adc_clk; 
    end process ; -- CLKDIV_PROC


    --driving the conversion counter & address input
    ADCFSM_PROC : process( i_clk,i_reset )
    begin
        if (i_reset = '0') then
            conversion_counter <= 0;
            r_adc_chan <= (others => '0'); 
        elsif rising_edge(i_clk) then
            if (r_enable = '1') then
                if r_adc_clk_rising_edge = '1' then
                    if (conversion_counter = 15) then
                        conversion_counter <= 0; 
                    else 
                        conversion_counter <= conversion_counter + 1; 
                    end if; 
                end if;

                if (conversion_counter > 5) then
                   r_adc_chan <= i_adc_chan; 
                end if; 
            end if; 
        end if ;
    end process; -- ADCFSM_PROC

    ADC_MOSI_PROC : process( i_clk,i_reset )
    begin
        if (i_reset = '0') then
            adc_mosi <= '0'; 
        elsif rising_edge(i_clk) then
            if (r_enable = '1') then
                if r_adc_clk_falling_edge = '1' then
                    case( conversion_counter ) is
                        when 2 => 
                            adc_mosi <= r_adc_chan(2); 
                        when 3 => 
                            adc_mosi <= r_adc_chan(1); 
                        when 4 => 
                            adc_mosi <= r_adc_chan(0); 
                        when others => adc_mosi <= '0'; 
                    end case ;
                end if;
            end if;      
        end if; 
    end process ; -- ADC_MOSI_PROC

    ADC_MISO_PROC : process( i_clk,i_reset )
    begin
        if (i_reset = '0') then 
            r_adc_conversion <= (others => '0'); 
        elsif (rising_edge(i_clk)) then
            r_adc_i <= adc_miso; 
            if (r_enable = '1') then
                if r_adc_clk_rising_edge = '1' then 
                    case(conversion_counter) is
                        when 4 => 
                            r_adc_conversion(11) <= r_adc_i; 
                        when 5 => 
                            r_adc_conversion(10) <= r_adc_i; 
                        when 6 => 
                            r_adc_conversion(9) <= r_adc_i; 
                        when 7 => 
                            r_adc_conversion(8) <= r_adc_i; 
                        when 8 => 
                            r_adc_conversion(7) <= r_adc_i; 
                        when 9 => 
                            r_adc_conversion(6) <= r_adc_i; 
                        when 10 => 
                            r_adc_conversion(5) <= r_adc_i; 
                        when 11 => 
                            r_adc_conversion(4) <= r_adc_i; 
                        when 12 => 
                            r_adc_conversion(3) <= r_adc_i;
                        when 13 => 
                            r_adc_conversion(2) <= r_adc_i; 
                        when 14 => 
                            r_adc_conversion(1) <= r_adc_i; 
                        when 15 => 
                            r_adc_conversion(0) <= r_adc_i; 
                        when others =>NULL;  --r_adc_conversion <= (others => '0'); 
                    end case; 
                end if;
            else
                r_adc_conversion <= (others => '0'); 
            end if;
        end if; 
    end process ; -- ADC_MISO_PROC

    ADCCONV_RESULT_PROC : process( i_clk,i_reset )
    begin
        if i_reset = '0' then 
            adc_conversion <= (others => '0'); 
            o_adc_conv_result <= '0'; 
        elsif rising_edge(i_clk) then
            if conversion_counter < 4 then
                o_adc_conv_result <= '1'; 
                adc_conversion <= r_adc_conversion; 
            else
            o_adc_conv_result <= '0'; 
            end if; 
        end if; 
    end process ; -- ADCCONV_RESULT_PROC
end architecture ;