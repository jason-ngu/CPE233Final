----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity reg_file_wrapper is
  Port (
           FROM_IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_B       : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_SCRATCH : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_ALU     : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL    : in STD_LOGIC_VECTOR (1 downto 0);
           ADDRX        : in STD_LOGIC_VECTOR (4 downto 0);
           ADDRY        : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR        : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           DX_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT       : out STD_LOGIC_VECTOR (7 downto 0));
end reg_file_wrapper;

architecture Behavioral of reg_file_wrapper is

component reg_file is
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADDRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADDRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component reg_file;

signal DIN_sig : std_logic_vector(7 downto 0);

begin
    
    mux : process(RF_WR_SEL, FROM_ALU, FROM_SCRATCH, FROM_B, FROM_IN_PORT)
    begin
        if (RF_WR_SEL = "00") then
            DIN_sig <= FROM_ALU;
        elsif (RF_WR_SEL = "01") then
            DIN_sig <= FROM_SCRATCH;
        elsif (RF_WR_SEL = "10") then
            DIN_sig <= FROM_B;
        else
            DIN_sig <= FROM_IN_PORT;
        end if;     
    end process mux;

    register_file : reg_file port map(
                                DIN => DIN_sig,
                                ADDRX  => ADDRX ,
                                ADDRY  => ADDRY ,
                                RF_WR  => RF_WR ,
                                CLK    => CLK   ,
                                DX_OUT => DX_OUT,
                                DY_OUT => DY_OUT);
                                
end Behavioral; 