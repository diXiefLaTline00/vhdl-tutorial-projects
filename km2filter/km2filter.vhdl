library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity km2filter is
    generic (
        data_width : integer := 16
    ); 
    port (
        clk : in std_logic;
        rst : in std_logic;
        x: in std_logic_vector(data_width -1 downto 0); 
        y: out std_logic_vector(data_width -1 downto 0)
    );
end km2filter;

architecture rtl of km2filter is
    signal xm0, xm1, xm2, y_reg: std_logic_vector(data_width + 1 downto 0);

    begin
    
    KM2F_PROC : process(clk,rst)
    begin
        if (rst = '1') then
            xm0 <= (others => '0'); 
            xm1 <= (others => '0'); 
            xm2 <= (others => '0');
            y_reg <= (others => '0'); 
        elsif rising_edge(clk) then
            --y(n)  = -1*x(n) + 2*x(n-1) - x(n-2)
            y_reg <= shift_left(xm1,1) - xm2 - xm0; 
            xm0 <= x; 
            xm1 <= xm0; 
            xm2 <= xm1; 
            y <= y_reg(data_width downto 1); 
        end if ;
    end process;

end architecture;