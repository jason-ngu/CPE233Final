library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    Port ( PC_COUNT : out STD_LOGIC_VECTOR(9 downto 0);
           RST : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR(9 downto 0);
           CLK : in STD_LOGIC);
end pc;

architecture Behavioral of pc is

signal CURRENT_VAL : unsigned(9 downto 0);
signal ZERO : std_logic_vector(9 downto 0);

begin 

PC_COUNT <= STD_LOGIC_VECTOR(CURRENT_VAL);
ZERO <= "0000000000";

process(CLK)
begin
    if rising_edge(CLK) then
        if RST = '1' then
            CURRENT_VAL <= unsigned(ZERO);
        elsif PC_LD = '1' then
            CURRENT_VAL <= unsigned(DIN);
        elsif PC_INC = '1' then
            CURRENT_VAL <= unsigned(CURRENT_VAL) + 1;            
        else
            null;
        end if;
    end if;
end process;

end Behavioral;
