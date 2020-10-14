-- from https://www.fpga4student.com/2017/01/a-low-pass-fir-filter-in-vhdl.html
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 

entity fir is
    generic (
        input_width : integer := 8; 
        output_width : integer := 16; 
        coef_width : integer := 8; 
        tap : integer := 11; 
        guard : integer := 0
    ); 

    port(
        Din : in std_logic_vector(input_width -1 downto 0); 
        Clk : in std_logic; 
        reset : in std_logic; 
        Dout : out std_logic_vector(output_width-1 downto 0)
    ); 
end fir;

architecture behavioural of fir is
    component N_bit_Reg
        generic (
            input_width : integer := 8
        ); 
        port(
            Q: out std_logic_vector(input_width-1 downto 0); 
            Clk: in std_logic; 
            reset : in std_logic; 
            D: in std_logic_vector(input_width - 1 downto 0)
        ); 
    end component; 

    type Coefficient_type is array(1 to tap) of std_logic_vector(coef_width - 1 downto 0);         
    
    constant coeficient: Coefficient_type :=   
    (     X"F1",  
         X"F3",  
         X"07",  
         X"26",  
         X"42",  
         X"4E",  
         X"42",  
         X"26",  
         X"07",  
         X"F3",  
         X"F1"                                     
    );
    
    type shift_reg_type is array(0 to tap -1) of std_logic_vector(input_width -1 downto 0); 
    signal shift_reg: shift_reg_type; 

    type mult_type is array(0 to tap -1) of std_logic_vector(input_width + coef_width -1 downto 0); 
    signal mult : mult_type;  

    type ADD_type is array (0 to tap-1) of std_logic_vector(input_width+coef_width-1 downto 0);  
    signal ADD: ADD_type;

    begin 
        shift_reg(0) <= Din; 
        mult(0) <= Din*coeficient(1); 
        ADD(0) <= Din*coeficient(1); 

        GEN_FIR: 
            for i in 0 to tap -2 generate
            begin
                N_bit_Reg_unit: N_bit_Reg generic map(input_width => 8)
                port map (
                    Clk => Clk,
                    reset => reset, 
                    D => shift_reg(i),
                    Q => shift_reg(i+1)
                ); 
                mult(i+1) <= shift_reg(i+1)*coeficient(i+2); 
                ADD(i+1) <= ADD(i) + mult(i+1); 
        end generate GEN_FIR; 
        Dout <= ADD(tap-1); 
end architecture; 
