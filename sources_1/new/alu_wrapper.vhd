----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_wrapper is
  Port (SEL             : in std_logic_vector(3 downto 0);
        A               : in std_logic_vector(7 downto 0);
        ALU_OPY_SEL     : in std_logic;
        FROM_REG        : in std_logic_vector(7 downto 0);
        FROM_PROG_ROM   : in std_logic_vector(7 downto 0);
        CIN             : in std_logic;
        RESULT          : out std_logic_vector(7 downto 0);
        C               : out std_logic;
        Z               : out std_logic);
end alu_wrapper;

architecture Behavioral of alu_wrapper is

component alu is
    Port ( SEL : in std_logic_vector(3 downto 0);
             A : in std_logic_vector(7 downto 0);
             B : in std_logic_vector(7 downto 0);
           CIN : in std_logic;
        RESULT : out std_logic_vector(7 downto 0);
             C : out std_logic;
             Z : out std_logic);
end component alu;

signal B_sig : std_logic_vector(7 downto 0);

begin

    arith_lu : alu port map ( 
                            SEL => SEL,
                            A => A,
                            B => B_sig,
                            CIN => CIN,
                            RESULT => RESULT,
                            C => C,
                            Z => Z
                            );
    
    mux : process(ALU_OPY_SEL, FROM_REG, FROM_PROG_ROM)
    begin
        if(ALU_OPY_SEL = '0') then
            B_sig <= FROM_REG;
        else
            B_sig <= FROM_PROG_ROM;
        end if;
    end process;

end Behavioral;
