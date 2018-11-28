library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clu is
  
  --Declaring all of our inputs and outputs to our control unit module--
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
end clu;

architecture Behavioral of clu is

--We will need 3 states to transition between
type state is (ST_INIT, ST_FETCH, ST_EXEC, ST_INTRPT);

--Instantiate two signals of type state
signal PS, NS : state;

--7 bit opcode signal currently being used to dictate what control sigs to configure
signal op_code : std_logic_vector(6 downto 0);

begin
    
    --Concatenate the two parts of the opcode
    op_code <= OPCODE_HI_5 & OPCODE_LO_2;
    
    --FSM process to switch between the three states on clock rising edge
    fsm : process(CLK, RESET)
    begin
        if rising_edge(CLK) then
            --Check for reset
            if RESET = '1' then
                PS <= ST_INIT;
            else
                PS <= NS;
            end if;
        end if;
    end process;

    -- Process to update the next state based on current state
    process (PS) begin
        
        -- The select line into mux that controlls the flow of the FSM
        case (PS) is
        
            when ST_INIT =>
                RST <= '1';
                NS <= ST_FETCH;
                PC_INC <= '0';
                
            when ST_FETCH =>
                RST <= '0';
                PC_INC <= '0';
                NS <= ST_EXEC;
                
            when ST_EXEC =>
                RST <= '0';
                PC_INC <= '1';
                if  INT = '1' then
                    NS <= ST_INTRPT;
                else
                    NS <= ST_FETCH;
                end if;
            
            when ST_INTRPT =>
                NS <= ST_FETCH;
            
            when others => 
                NS <= ST_INIT;
                RST <= '0';
                PC_INC <= '0';
                
        end case;
    end process;

    -- Process to associate the opcodes to the specific configuration of control signals
    process (PS, op_code, C, Z)
    begin
        
        -- Set all of the control signals to 0 to prevent any latches from forming
        I_SET <= '0';      
        I_CLR <= '0';      
        PC_LD <= '0';      
        PC_MUX_SEL <= "00";
        ALU_OPY_SEL <= '0';
        ALU_SEL <= "0000"; 
        RF_WR <= '0';      
        RF_WR_SEL <= "00"; 
        SP_LD <= '0';      
        SP_INCR <= '0';    
        SP_DECR <= '0';    
        SCR_WE <= '0';     
        SCR_ADDR_SEL <= "00";
        SCR_DATA_SEL <= '0';
        FLG_C_SET <= '0';  
        FLG_C_CLR <= '0';  
        FLG_C_LD <= '0';   
        FLG_Z_LD <= '0';   
        FLG_LD_SEL <= '0'; 
        FLG_SHAD_LD <= '0';
        IO_STRB <= '0';    
        
        if (PS = ST_EXEC) then
            case op_code is
                -- ADD Rd, Rs
                when "0000100" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0000";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- ADD Rd, imm
                when "1010000" | "1010001" | "1010010" | "1010011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0000";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- ADDC Rd, Rs
                when "0000101" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0001";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- ADDC Rd, imm
                when "1010100" | "1010101" | "1010110" | "1010111" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0001";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';   
                -- AND Rd, Rs
                when "0000000" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0101";
                    ALU_OPY_SEL <= '0';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';   
                -- AND Rd, imm
                when "1000000" | "1000001" | "1000010" | "1000011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0101";
                    ALU_OPY_SEL <= '1';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1'; 
                -- ASR Rd, Rs
                when "0100100" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1101";
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';  
                -- BRCC imm
                when "0010101" =>
                    if C = '0' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0'; 
                    end if;
                -- BRCS imm
                when "0010100" =>
                    if C = '1' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0'; 
                    end if;
                -- BREQ imm
                when "0010010" =>
                    if Z = '1' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0'; 
                    end if;
                -- BRN imm
                when "0010000" =>
                    PC_LD <= '1';
                    PC_MUX_SEL <= "00";
                -- BRNE imm
                when "0010011" =>
                    if Z = '0' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0'; 
                    end if;  
                -- CLC
                when "0110000" =>
                    FLG_C_CLR <= '1';
                    
                -- CLI 
                when "0110101" =>
                    I_CLR <= '1';
                -- RETIE
                when "0110111" =>
                    FLG_LD_SEL <= '1';
                    SP_LD <= '1';
                    SP_INCR <= '1';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "10";
                    PC_LD <= '1';
                    PC_MUX_SEL <= "01";
                    I_SET <= '1';
                -- RETID 
                when "0110110" =>
                    FLG_LD_SEL <= '1';
                    SP_LD <= '1';
                    SP_INCR <= '1';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "10";
                    PC_LD <= '1';
                    PC_MUX_SEL <= "01";
                    I_CLR <= '1';
                -- SEI
                when "0110100" =>
                    I_SET <= '1';
                    
                -- POP R1
                when "0100110" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "01";
                    SCR_ADDR_SEL <= "10";
                    SP_INCR <= '1';
                -- PUSH Rs
                when "0100101" =>
                    SCR_DATA_SEL <= '0';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "11";
                    SP_DECR <= '1';
                -- RET
                when "0110010" =>
                    PC_LD <= '1';
                    PC_MUX_SEL <= "01";
                    SCR_ADDR_SEL <= "10";
                    SP_INCR <= '1';
               
                -- CALL imm
                when "0010001" =>
                    PC_LD <= '1';
                    PC_MUX_SEL <= "00";
                    SCR_DATA_SEL <= '1';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "11";
                    SP_DECR <= '1';  

                -- WSP Rs
                when "0101000" =>
                    SP_LD <= '1';

                -- CMP Rd, Rs
                when "0001000" =>
                    RF_WR <= '0';
                    ALU_SEL <= "0100";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1'; 
                -- CMP Rd, imm
                when "1100000" | "1100001" | "1100010" | "1100011" =>
                    RF_WR <= '0';
                    ALU_SEL <= "0100";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- EXOR Rd, Rs
                when "0000010" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0111";
                    ALU_OPY_SEL <= '0';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';
                -- EXOR Rd, imm
                when "1001000" | "1001001" | "1001010" | "1001011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0111";
                    ALU_OPY_SEL <= '1';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';           
                -- IN Rd, imm
                when "1100100" | "1100101" | "1100110" | "1100111" => 
                    RF_WR <= '1';
                    RF_WR_SEL <= "11";
                -- LD Rd, Rs
                when "0001010" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "01";
                    SCR_WE <= '0';
                    SCR_ADDR_SEL <= "00";
                -- LD Rd, imm
                when "1110000" | "1110001" | "1110010" | "1110011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "01";
                    SCR_WE <= '0';
                    SCR_ADDR_SEL <= "01";
                -- LSL Rd, Rs
                when "0100000" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1001";
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- LSR Rd, Rs
                when "0100001" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1010";
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- MOV Rd, Rs
                when "0001001" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1110";
                    ALU_OPY_SEL <= '0';
                -- MOV Rd, imm
                when "1101100" | "1101101" | "1101110" | "1101111" => 
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1110";
                    ALU_OPY_SEL <= '1';
                -- OR Rd, Rs
                when "0000001" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0110";
                    ALU_OPY_SEL <= '0';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';
                -- OR Rd, imm
                when "1000100" | "1000101" | "1000110" | "1000111" =>
                    RF_WR <= '1';      
                    RF_WR_SEL <= "00"; 
                    ALU_SEL <= "0110"; 
                    ALU_OPY_SEL <= '1';
                    FLG_C_CLR <= '1';  
                    FLG_Z_LD <= '1';   
                -- OUT imm, Rd
                when "1101000" | "1101001" | "1101010" | "1101011" =>
                    IO_STRB <= '1';
                -- ROL Rd
                when "0100010" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1011";
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- ROR Rd
                when "0100011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1100";
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- SEC 
                when "0110001" =>
                    FLG_C_SET <= '1';
                -- ST Rd, Rs
                when "0001011" =>
                    SCR_DATA_SEL <= '0';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "00";
                -- ST Rd, imm
                when "1110100" | "1110101" | "1110110" | "1110111" =>
                    SCR_DATA_SEL <= '0';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "01";
                -- SUB Rd, Rs
                when "0000110" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0010";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- SUB Rd, imm
                when "1011000" | "1011001" | "1011010" | "1011011" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0010";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- SUBC Rd, Rs
                when "0000111" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0011";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- SUBC Rd, imm
                when "1011100" | "1011101" | "1011110" | "1011111" =>
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "0011";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                -- TEST Rd, Rs
                when "0000011" =>
                    RF_WR <= '0';
                    ALU_SEL <= "1000";
                    ALU_OPY_SEL <= '0';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';
                -- TEST Rd, imm
                when "1001100" | "1001101" | "1001110" | "1001111" =>
                    RF_WR <= '0';
                    ALU_SEL <= "1000";
                    ALU_OPY_SEL <= '1';
                    FLG_C_CLR <= '1';
                    FLG_Z_LD <= '1';
                    
                -- default case
                when others =>
                    I_SET <= '0';        
                    I_CLR <= '0';        
                    PC_LD <= '0';        
                    PC_MUX_SEL <= "00";  
                    ALU_OPY_SEL <= '0';  
                    ALU_SEL <= "0000";   
                    RF_WR <= '0';        
                    RF_WR_SEL <= "00";   
                    SP_LD <= '0';        
                    SP_INCR <= '0';      
                    SP_DECR <= '0';      
                    SCR_WE <= '0';       
                    SCR_ADDR_SEL <= "00";
                    SCR_DATA_SEL <= '0'; 
                    FLG_C_SET <= '0';    
                    FLG_C_CLR <= '0';    
                    FLG_C_LD <= '0';     
                    FLG_Z_LD <= '0';     
                    FLG_LD_SEL <= '0';   
                    FLG_SHAD_LD <= '0';  
                    IO_STRB <= '0';      
            end case;
        
        elsif (PS = ST_INTRPT) then
            PC_MUX_SEL <= "10";
            PC_LD <= '1';
            SCR_DATA_SEL <= '1';
            SCR_WE <= '1';
            SCR_ADDR_SEL <= "11";
            SP_DECR <= '1';
            FLG_SHAD_LD <= '1';
        
        --When the present state is not the EXECUTE state...
        else
            I_SET <= '0';
            I_CLR <= '0';
            PC_LD <= '0';
            PC_MUX_SEL <= "00";
            ALU_OPY_SEL <= '0';
            ALU_SEL <= "0000";
            RF_WR <= '0';
            RF_WR_SEL <= "00";
            SP_LD <= '0';
            SP_INCR <= '0';
            SP_DECR <= '0';
            SCR_WE <= '0';
            SCR_ADDR_SEL <= "00";
            SCR_DATA_SEL <= '0';
            FLG_C_SET <= '0';
            FLG_C_CLR <= '0';
            FLG_C_LD <= '0';
            FLG_Z_LD <= '0';
            FLG_LD_SEL <= '0';
            FLG_SHAD_LD <= '0';
            IO_STRB <= '0'; 
            
        end if;
        
    end process;
    
    end Behavioral;
