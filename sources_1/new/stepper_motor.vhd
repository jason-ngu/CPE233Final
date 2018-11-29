library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stepper_motor is
  Port ( DIN : in std_logic_vector(7 downto 0);
         CLK : in std_logic;
         STEP : out std_logic;
         DIR : out std_logic);
end stepper_motor;

architecture Behavioral of stepper_motor is

signal prev_din : std_logic_vector (7 downto 0);
signal current_din : std_logic_vector ( 7 downto 0);
signal data_changed : std_logic;
signal enable : std_logic;
signal count : integer := 0;

begin

current_din <= DIN;

reg: process(CLK)
begin
    if rising_edge(CLK) then
        prev_din <= current_din;
    end if;
end process;

trigger_change: process(prev_din, current_din)
begin
    if prev_din = current_din then
        data_changed <= '0';
    else
        data_changed <= '1';
    end if;
end process;

on_change: process(data_changed, CLK)
begin
    if rising_edge(data_changed) then
        count <= 0;
    end if;
    
    if rising_edge(CLK) then
        if count < to_integer(unsigned(current_din)) then
            count <= count + 1;
            enable <= '1';
        else
            enable <= '0';
        end if;
    end if;
end process;


end Behavioral;
