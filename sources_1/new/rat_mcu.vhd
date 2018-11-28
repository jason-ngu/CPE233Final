----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity rat_mcu is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
end rat_mcu;

architecture Behavioral of rat_mcu is

component interrupt_reg is
  Port ( SET : in std_logic;
         CLR : in std_logic;
         CLK : in std_logic;
         OUTPUT : out std_logic);
end component interrupt_reg;

component pc_driver is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR(9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR(9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR(1 downto 0);
           PC_COUNT : out STD_LOGIC_VECTOR(9 downto 0);
           RST : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           CLK : in STD_LOGIC );
end component pc_driver;

component prog_rom is 
   port (     ADDRESS : in std_logic_vector(9 downto 0); 
          INSTRUCTION : out std_logic_vector(17 downto 0); 
                  CLK : in std_logic);  
end component prog_rom;

component reg_file_wrapper is
  Port (FROM_IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_B : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_SCRATCH : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_ALU : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           ADDRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADDRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component reg_file_wrapper;

component alu_wrapper is
  Port ( SEL : in std_logic_vector(3 downto 0);
             A : in std_logic_vector(7 downto 0);
             ALU_OPY_SEL : in std_logic;
             FROM_REG : in std_logic_vector(7 downto 0);
             FROM_PROG_ROM : in std_logic_vector(7 downto 0);
           CIN : in std_logic;
        RESULT : out std_logic_vector(7 downto 0);
             C : out std_logic;
             Z : out std_logic);
end component alu_wrapper;

component scratch_ram_wrapper is
  Port (   SCR_DATA_SEL : in STD_LOGIC;
           DATA_FROM_PC : in STD_LOGIC_VECTOR (9 downto 0);
           DATA_FROM_REG : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           ADDR_FROM_REG : in STD_LOGIC_VECTOR (7 downto 0);
           ADDR_FROM_IMM : in STD_LOGIC_VECTOR (7 downto 0);
           ADDR_FROM_SP : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0) );
end component scratch_ram_wrapper;

component flags is
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
end component flags;

component clu is
  Port ( C : in std_logic;
         Z : in std_logic;
         INT : in std_logic;
         RESET : in std_logic;
         OPCODE_HI_5 : in std_logic_vector(4 downto 0);
         OPCODE_LO_2 : in std_logic_vector(1 downto 0);
         CLK : in std_logic;
         I_SET : out std_logic;
         I_CLR : out std_logic;
         PC_LD : out std_logic;
         PC_INC : out std_logic;
         PC_MUX_SEL : out std_logic_vector(1 downto 0);
         ALU_OPY_SEL : out std_logic;
         ALU_SEL : out std_logic_vector(3 downto 0);
         RF_WR : out std_logic;
         RF_WR_SEL : out std_logic_vector(1 downto 0);
         SP_LD : out std_logic;
         SP_INCR : out std_logic;
         SP_DECR : out std_logic;
         SCR_WE : out std_logic;
         SCR_ADDR_SEL : out std_logic_vector(1 downto 0);
         SCR_DATA_SEL : out std_logic;
         FLG_C_SET : out std_logic;
         FLG_C_CLR : out std_logic;
         FLG_C_LD : out std_logic;
         FLG_Z_LD : out std_logic;
         FLG_LD_SEL : out std_logic;
         FLG_SHAD_LD : out std_logic;
         RST : out std_logic;
         IO_STRB : out std_logic);
end component clu;

component stack_pointer is
      Port ( DATA : in std_logic_vector(7 downto 0);
            RESET : in std_logic;
             LOAD : in std_logic;
             INCR : in std_logic;
             DECR : in std_logic;
              CLK : in std_logic;
             DOUT : out std_logic_vector(7 downto 0));
end component stack_pointer;

signal C_sig : std_logic;
signal Z_sig : std_logic;
signal INT_sig : std_logic;
signal I_SET_sig : std_logic;
signal I_CLR_sig : std_logic;
signal I_OUT_sig : std_logic;
signal I_CLU_sig : std_logic;
signal PC_LD_sig : std_logic;
signal PC_INC_sig : std_logic;
signal PC_MUX_SEL_sig : std_logic_vector(1 downto 0);
signal ALU_OPY_SEL_sig : std_logic;
signal ALU_SEL_sig : std_logic_vector(3 downto 0);
signal RF_WR_sig : std_logic;
signal RF_WR_SEL_sig : std_logic_vector(1 downto 0);
signal SP_LD_sig : std_logic;
signal SP_INCR_sig : std_logic;
signal SP_DECR_sig : std_logic;
signal SCR_WE_sig : std_logic;
signal SCR_ADDR_SEL_sig : std_logic_vector(1 downto 0);
signal SCR_DATA_SEL_sig : std_logic;
signal FLG_C_SET_sig : std_logic;
signal FLG_C_CLR_sig : std_logic;
signal FLG_C_LD_sig : std_logic;
signal FLG_Z_LD_sig : std_logic;
signal FLG_LD_SEL_sig : std_logic;
signal FLG_SHAD_LD_sig : std_logic;
signal RST_sig : std_logic;

signal A_sig : std_logic_vector (7 downto 0);
signal B_sig : std_logic_vector (7 downto 0);

signal ADDRESS_sig : std_logic_vector (9 downto 0);
signal INSTRUCTION_sig : std_logic_vector (17 downto 0);

signal DX_OUT_sig : std_logic_vector (7 downto 0);
signal DY_OUT_sig : std_logic_vector (7 downto 0);

signal SCRATCH_OUT_sig : std_logic_vector (9 downto 0);

signal ALU_RESULT_sig : std_logic_vector (7 downto 0);

signal ALU_C_OUT_sig : std_logic;
signal ALU_Z_OUT_sig : std_logic;

signal SP_DOUT_sig : std_logic_vector (7 downto 0);


begin
    A_sig <= DX_OUT_sig;
    B_sig <= SP_DOUT_sig;
    
    INT_sig <= INT;
    PORT_ID <= INSTRUCTION_sig(7 downto 0);
    OUT_PORT <= DX_OUT_sig;
    
    I_CLU_sig <= INT_sig AND I_OUT_sig;
    
    control_unit : clu port map(
        C => C_sig,
        Z => Z_sig,
        INT => I_CLU_sig,
        RESET => RESET,
        OPCODE_HI_5 => INSTRUCTION_sig(17 downto 13),
        OPCODE_LO_2 => INSTRUCTION_sig(1 downto 0),
        CLK => CLK,
        I_SET => I_SET_sig,
        I_CLR => I_CLR_sig,
        PC_LD => PC_LD_sig,
        PC_INC => PC_INC_sig,
        PC_MUX_SEL => PC_MUX_SEL_sig,
        ALU_OPY_SEL => ALU_OPY_SEL_sig,
        ALU_SEL => ALU_SEL_sig,
        RF_WR => RF_WR_sig,
        RF_WR_SEL => RF_WR_SEL_sig,
        SP_LD => SP_LD_sig,
        SP_INCR => SP_INCR_sig,
        SP_DECR => SP_DECR_sig,
        SCR_WE => SCR_WE_sig,
        SCR_ADDR_SEL => SCR_ADDR_SEL_sig,
        SCR_DATA_SEL => SCR_DATA_SEL_sig,
        FLG_C_SET => FLG_C_SET_sig,
        FLG_C_CLR => FLG_C_CLR_sig,
        FLG_C_LD => FLG_C_LD_sig,
        FLG_Z_LD => FLG_Z_LD_sig,
        FLG_LD_SEL => FLG_LD_SEL_sig,
        FLG_SHAD_LD => FLG_SHAD_LD_sig,
        RST => RST_sig,
        IO_STRB => IO_STRB
    );
    
    pc : pc_driver port map(
        RST         => RST_sig, 
        PC_LD       => PC_LD_sig, 
        PC_INC      => PC_INC_sig, 
        CLK         => CLK,
        PC_MUX_SEL  => PC_MUX_SEL_sig,
        FROM_IMMED  => INSTRUCTION_sig (12 downto 3),
        FROM_STACK  => SCRATCH_OUT_sig,
        PC_COUNT    => ADDRESS_sig
    );
    
    
    reg_file : reg_file_wrapper port map(
        RF_WR        => RF_WR_sig,
        RF_WR_SEL    => RF_WR_SEL_sig,
        CLK          => CLK,
        FROM_IN_PORT => IN_PORT,
        FROM_B       => "00000000", --TODO
        FROM_SCRATCH => SCRATCH_OUT_sig(7 downto 0),
        FROM_ALU     => ALU_RESULT_sig,
        ADDRX        => INSTRUCTION_sig (12 downto 8),
        ADDRY        => INSTRUCTION_sig (7 downto 3),
        DX_OUT       => DX_OUT_sig,
        DY_OUT       => DY_OUT_sig
    );
    
    alu : alu_wrapper port map(
        SEL           => ALU_SEL_sig,
        A             => DX_OUT_sig,
        ALU_OPY_SEL   => ALU_OPY_SEL_sig,
        FROM_REG      => DY_OUT_sig,
        FROM_PROG_ROM => INSTRUCTION_sig(7 downto 0),
        CIN           => C_sig,
        RESULT        => ALU_RESULT_sig,
        C             => ALU_C_OUT_sig,
        Z             => ALU_Z_OUT_sig
        );
    
    scratch_ram : scratch_ram_wrapper port map(
        SCR_DATA_SEL  => SCR_DATA_SEL_sig,
        DATA_FROM_PC  => ADDRESS_sig,
        DATA_FROM_REG => DX_OUT_sig,
        SCR_ADDR_SEL  => SCR_ADDR_SEL_sig,
        ADDR_FROM_REG => DY_OUT_sig,
        ADDR_FROM_IMM => INSTRUCTION_sig(7 downto 0),
        ADDR_FROM_SP  => SP_DOUT_sig,
        SCR_WE        => SCR_WE_sig,
        CLK           => CLK,
        DATA_OUT      => SCRATCH_OUT_sig
        ); 
       
    
    program_rom : prog_rom port map(
        ADDRESS => ADDRESS_sig,
        INSTRUCTION => INSTRUCTION_sig,
        CLK => CLK
    );
    
    flag : flags port map(
        FLG_C_SET   => FLG_C_SET_sig,
        FLG_C_CLR   => FLG_C_CLR_sig,
        FLG_C_LD    => FLG_C_LD_sig,
        FLG_Z_LD    => FLG_Z_LD_sig,
        FLG_LD_SEL  => FLG_LD_SEL_sig,
        FLG_SHAD_LD => FLG_SHAD_LD_sig,
        C           => ALU_C_OUT_sig,
        Z           => ALU_Z_OUT_sig,
        CLK         => CLK,
        C_FLAG      => C_sig,
        Z_FLAG      => Z_sig
        );
        
    sp : stack_pointer port map(
          DATA => A_sig,
         RESET => RST_sig,
          LOAD => SP_LD_sig,
          INCR => SP_INCR_sig,
          DECR => SP_DECR_sig,
           CLK => CLK,
          DOUT => SP_DOUT_sig
    );
    
    interrupt : process (CLK)
    begin
    if rising_edge(CLK) then
        if I_SET_sig = '1' then
                I_OUT_sig <= '1';
            elsif I_CLR_sig = '1' then
                I_OUT_sig <= '0';
            end if;
        end if;
    end process;
    
--    interrupt : interrupt_reg port map(
--           SET => I_SET_sig,
--           CLR => I_CLR_sig,
--           CLK => CLK,
--          OUTPUT => I_OUT_sig
--   );      
    
end Behavioral;
