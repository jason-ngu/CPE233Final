library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c_reg is
  Port ( LD : in std_logic;
         input : in std_logic;
         set : in std_logic;
         clr : in std_logic;
         CLK : in std_logic;
         output : out std_logic);
end c_reg;

architecture Behavioral of c_reg is

signal out_sig : std_logic := '0';

begin
 
output <= out_sig;

process(clk)
    begin
    if rising_edge(clk) then
        if clr = '1' then
            out_sig <= '0';
        elsif set = '1' then
            out_sig <= '1';
        elsif LD = '1' then
            out_sig <= input;
        end if;
    end if;
end process;
end Behavioral;
