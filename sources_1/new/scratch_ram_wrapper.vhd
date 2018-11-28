----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scratch_ram_wrapper is
  Port (   SCR_DATA_SEL     : in STD_LOGIC;
           DATA_FROM_PC     : in STD_LOGIC_VECTOR (9 downto 0);
           DATA_FROM_REG    : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_SEL     : in STD_LOGIC_VECTOR (1 downto 0);
           ADDR_FROM_REG    : in STD_LOGIC_VECTOR (7 downto 0);
           ADDR_FROM_IMM    : in STD_LOGIC_VECTOR (7 downto 0);
           ADDR_FROM_SP     : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_WE           : in STD_LOGIC;
           CLK              : in STD_LOGIC;
           DATA_OUT         : out STD_LOGIC_VECTOR (9 downto 0) );
end scratch_ram_wrapper;

architecture Behavioral of scratch_ram_wrapper is

signal DATA_IN_sig : std_logic_vector (9 downto 0);
signal SCR_ADDR_sig : std_logic_vector (7 downto 0);


component scratch_ram is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end component scratch_ram;

begin

    ram : scratch_ram port map(
                            DATA_IN => DATA_IN_sig,
                            SCR_ADDR => SCR_ADDR_sig,
                            SCR_WE => SCR_WE,
                            CLK => CLK,
                            DATA_OUT => DATA_OUT
                            );
                            
    data_mux : process (SCR_DATA_SEL, DATA_FROM_REG, DATA_FROM_PC)
    begin
        if(SCR_DATA_SEL = '0') then
            DATA_IN_sig <= "00" & DATA_FROM_REG;
        else
            DATA_IN_sig <= std_logic_vector(unsigned(DATA_FROM_PC)+1);
        end if;
    
    end process;
    
    addr_mux : process (SCR_ADDR_SEL, ADDR_FROM_REG, ADDR_FROM_IMM, ADDR_FROM_SP)
    begin
        if(SCR_ADDR_SEL = "00") then
            SCR_ADDR_sig <= ADDR_FROM_REG;
        elsif(SCR_ADDR_SEL = "01") then
            SCR_ADDR_sig <= ADDR_FROM_IMM;
        elsif(SCR_ADDR_SEL = "10") then
            SCR_ADDR_sig <= ADDR_FROM_SP;
        else
            SCR_ADDR_sig <= std_logic_vector(unsigned(ADDR_FROM_SP)-1);
        end if;
    end process;

end Behavioral;
