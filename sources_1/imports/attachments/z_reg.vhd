library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity z_reg is
  Port ( LD : in std_logic;
         input : in std_logic;
         CLK : in std_logic;
         output : out std_logic);
end z_reg;

architecture Behavioral of z_reg is

signal out_sig : std_logic := '0';

begin
     output <= out_sig;
     process(clk, input)
         begin
         if rising_edge(clk) then
             if LD = '1' then
                 out_sig <= input;
             end if;
         end if;
     end process;
end Behavioral;
