library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stepper_motor is
  Port ( DIN : in std_logic_vector(7 downto 0);
         CLK : in std_logic;
         STEP : out std_logic;
         DIR : out std_logic;
         data_changed_debug : out std_logic;
         enable_debug : out std_logic);
end stepper_motor;

architecture Behavioral of stepper_motor is

component scale_clock is
  port (
    clk_50Mhz : in  std_logic;
    rst       : in  std_logic;
    clk_2Hz   : out std_logic);
end component scale_clock;

signal clk_sig : std_logic;
signal prev_din : std_logic_vector (6 downto 0);
signal current_din : std_logic_vector ( 6 downto 0);
signal data_changed : std_logic;
signal enable : std_logic;
signal count : integer := 0;

begin

current_din <= DIN(6 downto 0);

DIR <= DIN(7);

data_changed_debug <= data_changed;
enable_debug <= enable;

reg: process(clk_sig)
begin
    if rising_edge(clk_sig) then
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

on_change: process(data_changed, clk_sig)
begin
    if (data_changed = '1') then
        count <= 0;
    
    elsif rising_edge(clk_sig) then
    
        if count < to_integer(unsigned(current_din)) then
            count <= count + 1;
            enable <= '1';
        else
            enable <= '0';
        end if;
    end if;
end process;

set_out: process(enable,clk_sig)
begin
    if enable = '1' then
        STEP <= clk_sig;
    else
        STEP <= '0';
    end if;
end process;

clock : scale_clock port map(
        clk_50Mhz => clk,
        rst => '0',     
        clk_2Hz => clk_sig);

end Behavioral;
