library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity top_ent is
end top_ent ; 

architecture sim of top_ent is
--declarative region of the architecture
signal clk : std_logic := '1'; 
constant period : time := 20 ns; --time type is only for simulation, have 

signal rst_n: std_logic := '0'; 
signal segments: std_logic_vector(6 downto 0); 
signal digit_sel: std_logic;

begin 
 -- Device under test
    DUT : entity work.top(rtl)
    port map (
    clk => clk,
    rst_n => rst_n,
    segments => segments,
    digit_sel => digit_sel
    );

    CLOCK_PROC : process
    begin
        wait for period /2; 
        clk <= not clk;
    end process ; -- CLOCK_PROC, --process loops around if no sensitivity list

    RESET_PROC : process
    begin
        wait for 10 ns; 
        rst_n <= '1'; 
        wait; 
    end process ; -- RESET_PROC

end architecture; 