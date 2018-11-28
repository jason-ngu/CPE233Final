library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_driver is
    Port ( FROM_IMMED   : in STD_LOGIC_VECTOR(9 downto 0);
           FROM_STACK   : in STD_LOGIC_VECTOR(9 downto 0);
           PC_MUX_SEL   : in STD_LOGIC_VECTOR(1 downto 0);
           PC_COUNT     : out STD_LOGIC_VECTOR(9 downto 0);
           RST          : in STD_LOGIC;
           PC_LD        : in STD_LOGIC;
           PC_INC       : in STD_LOGIC;
           CLK          : in STD_LOGIC );
end pc_driver;

architecture Behavioral of pc_driver is

component pc
    port(PC_COUNT : out STD_LOGIC_VECTOR(9 downto 0);
         RST : in STD_LOGIC;
         PC_LD : in STD_LOGIC;
         PC_INC : in STD_LOGIC;
         DIN : in STD_LOGIC_VECTOR(9 downto 0);
         CLK : in STD_LOGIC);
end component;


signal D : std_logic_vector(9 downto 0) := "0000000000";

begin

    prog_count : pc port map(
        PC_COUNT=>PC_COUNT, 
        RST=>RST, 
        PC_LD=>PC_LD, 
        PC_INC=>PC_INC, 
        DIN=>D, 
        CLK=>CLK);

    mux : process (PC_MUX_SEL, FROM_IMMED, FROM_STACK)
    begin
        case PC_MUX_SEL is
            when "00" =>    D <= FROM_IMMED;
            when "01" =>    D <= FROM_STACK;
            when "10" =>    D <= "1111111111";
            when others =>    D <= "1111111111";
        end case;
    end process mux;

end Behavioral;
