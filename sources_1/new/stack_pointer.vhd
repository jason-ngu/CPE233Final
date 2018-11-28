library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stack_pointer is
  Port ( DATA : in std_logic_vector(7 downto 0);
        RESET : in std_logic;
         LOAD : in std_logic;
         INCR : in std_logic;
         DECR : in std_logic;
          CLK : in std_logic;
         DOUT : out std_logic_vector(7 downto 0));
end stack_pointer;

architecture Behavioral of stack_pointer is

signal DOUT_sig : std_logic_vector(7 downto 0);

begin

DOUT <= DOUT_sig;

process(CLK, RESET, LOAD, INCR, DECR)
    begin
       if rising_edge(clk) then
            if  RESET = '1' then
                DOUT_sig <= "00000000";
            elsif LOAD = '1' then
                DOUT_sig <= DATA;
            elsif INCR = '1' then
                DOUT_sig <= std_logic_vector(unsigned(DOUT_sig) + 1);
            elsif DECR = '1' then
                DOUT_sig <= std_logic_vector(unsigned(DOUT_sig) - 1);
            end if;
        end if;
end process;

end Behavioral;
