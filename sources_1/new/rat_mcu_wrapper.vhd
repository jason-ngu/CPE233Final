----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rat_mcu_wrapper is
    Port ( SWITCHES : in STD_LOGIC_VECTOR (7 downto 0);
           PMOD : in STD_LOGIC_VECTOR (7 downto 0);
           BTNR : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           CLK : in STD_LOGIC;
           LEDS : out STD_LOGIC_VECTOR (15 downto 0);
           ANODES : out STD_LOGIC_VECTOR (3 downto 0);
           CATHODES : out STD_LOGIC_VECTOR (7 downto 0)
           );
end rat_mcu_wrapper;


architecture Behavioral of rat_mcu_wrapper is

component sseg_dec is
    Port (     ALU_VAL : in std_logic_vector(7 downto 0); 
               CLK : in std_logic;
               DISP_EN : out std_logic_vector(3 downto 0);
               SEGMENTS : out std_logic_vector(7 downto 0));
end component;

component db_1shot_FSM is
    Port ( A    : in STD_LOGIC;
           CLK  : in STD_LOGIC;
           A_DB : out STD_LOGIC);
end component db_1shot_FSM;

component rat_mcu is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
end component;

signal IN_PORT_sig : std_logic_vector (7 downto 0);
signal PORT_ID_sig : std_logic_vector (7 downto 0);
signal CLK_sig : std_logic := '0';
signal IO_STRB_sig : std_logic;
signal OUT_PORT_sig : std_logic_vector (7 downto 0);
signal D_sig : std_logic_vector (7 downto 0);
signal OPEN_sig : std_logic_vector (7 downto 0);
signal SSEG_sig : std_logic_vector (7 downto 0);
signal INT_sig : std_logic;

begin

debouncer : db_1shot_FSM port map(A => BTNL,
                                  CLK => CLK,
                                  A_DB => INT_sig);

internal : rat_mcu port map(INT => INT_sig,
                            RESET => BTNR,
                            IN_PORT => IN_PORT_sig,
                            CLK => CLK_sig,
                            IO_STRB => IO_STRB_sig,
                            OUT_PORT => OUT_PORT_sig,
                            PORT_ID => PORT_ID_sig);

mux: process(PORT_ID_sig, PMOD, SWITCHES)
begin
    case(PORT_ID_sig) is 
        when ("11111111") => IN_PORT_sig <= SWITCHES;
        when ("00000001") => IN_PORT_sig <= PMOD;
        when others => IN_PORT_sig <= SWITCHES;
    end case;
end process mux;


demux: process(PORT_ID_sig, CLK_sig, IO_STRB_sig)
begin
    if rising_edge(CLK_sig) then
        if IO_STRB_sig = '1' then
            case(PORT_ID_sig) is 
                when ("10000001") => SSEG_sig <= OUT_PORT_sig;
                when ("00000010") => LEDS(7 downto 0) <= OUT_PORT_sig;
                when others => LEDS(7 downto 0) <= OUT_PORT_sig;
            end case;
        end if;
    end if;
end process demux;


clk_div: process(CLK) begin
    if rising_edge(CLK) then
        CLK_sig <= not(CLK_sig);
    end if;
end process;

segment: sseg_dec port map(
                            ALU_VAL     =>  SSEG_sig,
                            CLK         =>  CLK_sig,
                            DISP_EN     =>  ANODES,
                            SEGMENTS    =>  CATHODES
                            );

end Behavioral;