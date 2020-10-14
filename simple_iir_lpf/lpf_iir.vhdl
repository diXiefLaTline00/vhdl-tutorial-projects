library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity lpf_iir is
    generic (
        input_width : natural := 16; 
        scale: natural := 2
    ); 
    port (
        xn: in signed(input_width-1 downto 0); 
        yn: out signed(input_width-1 downto 0); 
        clk, reset : in std_logic
    ); 
end lpf_iir; 

architecture logic of lpf_iir is
    --define registers
    signal tmp: signed(input_width-1 downto 0);
    begin
        process(clk) begin
            if (reset='1') then
                tmp <= (others => '0');
            elsif (rising_edge(clk)) then
                tmp <= tmp + shift_right(xn-tmp,scale); --(sra (xn - tmp) scale); 
            end if; 
            yn <= tmp; 
        end process; 
end architecture;
