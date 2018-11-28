----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan, Jason Ngu
-- Design: Register File
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity reg_file is
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADDRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADDRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end reg_file;

architecture Behavioral of reg_file is
    type memory is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal regs : memory := (others => ( others => '0'));

begin
    DX_OUT <= regs(to_integer(unsigned(ADDRX)));
    DY_OUT <= regs(to_integer(unsigned(ADDRY)));

    load_data: process(CLK, DIN, ADDRX, RF_WR)
    begin
        if rising_edge(CLK) then
            if RF_WR = '1' then
                regs(to_integer(unsigned(ADDRX))) <= DIN;
            end if;
        end if; 
    end process;
    
end Behavioral;
