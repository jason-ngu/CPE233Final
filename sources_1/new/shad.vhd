library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shad is
  Port ( LD : in std_logic;
         INPUT : in std_logic;
         CLK : in std_logic;
         OUTPUT : out std_logic );
end shad;

architecture Behavioral of shad is

signal out_sig : std_logic := '0';

begin
    OUTPUT <= out_sig;
    process(CLK, LD, INPUT)
    begin
        if rising_edge(clk) then
            if LD = '1' then
                out_sig <= INPUT;
            end if;
        end if;
    end process;
end Behavioral;
