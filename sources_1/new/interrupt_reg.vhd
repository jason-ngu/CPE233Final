library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity interrupt_reg is
  Port ( SET : in std_logic;
         CLR : in std_logic;
         CLK : in std_logic;
         OUTPUT : out std_logic);
end interrupt_reg;

architecture Behavioral of interrupt_reg is

signal OUT_sig : std_logic;

begin

OUTPUT <= OUT_sig;

process(CLK, SET, CLR)
begin
    if rising_edge(clk) then
        if SET = '1' then
            OUT_sig <= '1';
        elsif CLR = '1' then
            OUT_sig <= '0';
        end if;
    end if;
end process;

end Behavioral;
