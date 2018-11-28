----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flags is
  Port (FLG_C_SET : in std_logic;
        FLG_C_CLR : in std_logic;
        FLG_C_LD : in std_logic;
        FLG_Z_LD : in std_logic;
        FLG_LD_SEL : in std_logic;
        FLG_SHAD_LD : in std_logic;
        CLK : in std_logic;
        C : in std_logic;
        Z : in std_logic;
        C_FLAG : out std_logic;
        Z_FLAG : out std_logic);
end entity flags;

architecture Behavioral of flags is

component c_reg is
  Port ( LD     : in std_logic;
         input  : in std_logic;
         set    : in std_logic;
         clr    : in std_logic;
         CLK    : in std_logic;
         output : out std_logic);
end component c_reg;

component z_reg is
  Port ( LD : in std_logic;
         input : in std_logic;
         CLK : in std_logic;
         output : out std_logic);
end component z_reg;

component shad is
  Port ( LD : in std_logic;
         INPUT : in std_logic;
         CLK : in std_logic;
         OUTPUT : out std_logic );
end component shad;

signal z_in_sig : std_logic;
signal c_in_sig : std_logic;
signal z_out_sig : std_logic := '0';
signal c_out_sig : std_logic := '0';
signal shad_c_out_sig : std_logic := '0';
signal shad_z_out_sig : std_logic := '0';

begin
    
    C_FLAG <= c_out_sig;
    Z_FLAG <= z_out_sig;

    z_register : z_reg port map (
        input => z_in_sig,
        LD => FLG_Z_LD,
        CLK => CLK,
        output => z_out_sig
        );
    
    c_register : c_reg port map (
        LD => FLG_C_LD,
        SET => FLG_C_SET,
        input => c_in_sig,
        CLK => CLK,
        CLR => FLG_C_CLR,
        output => c_out_sig
        );
-- Mux that loads in C, Z, or output from shadow flag registers
-- Loads C/Z if select is low
-- Loads shadow flag outputs if select is high
    mux_z : process (FLG_LD_SEL, C, Z)
    begin
        if (FLG_LD_SEL = '0') then
            c_in_sig <= C;
            z_in_sig <= Z;
        else
            c_in_sig <= shad_c_out_sig;
            z_in_sig <= shad_z_out_sig;
        end if;
    end process mux_z;
-- Process to handle C Shadow Flag
-- Outputs the loaded input value from C flag register    
    shad_c : process (CLK, FLG_SHAD_LD)
    begin
        if rising_edge(CLK) then
            if FLG_SHAD_LD = '1' then
                shad_c_out_sig <= c_out_sig;
            end if;
        end if;
    end process shad_c;
-- Process to handle Z Shadow Flag
-- Outputs the loaded input value from Z flag register
    shad_z : process (CLK, FLG_SHAD_LD)
    begin
        if rising_edge(CLK) then
            if FLG_SHAD_LD = '1' then
                shad_z_out_sig <= z_out_sig;
            end if;
        end if;
    end process shad_z;

end Behavioral;
