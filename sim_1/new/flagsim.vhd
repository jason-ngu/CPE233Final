----------------------------------------------------------------------------------
-- Name: Vasanth Sadhasivan
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity siml is
end siml;

architecture Behavioral of siml is


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

        signal FLG_C_SET   : std_logic;
        signal FLG_C_CLR   : std_logic;
        signal FLG_C_LD    : std_logic;
        signal FLG_Z_LD    : std_logic;
        signal FLG_LD_SEL  : std_logic;
        signal FLG_SHAD_LD : std_logic;
        signal CLK         : std_logic;
        signal C           : std_logic;
        signal Z           : std_logic;
        signal C_FLAG      : std_logic := '0';
        signal Z_FLAG      : std_logic := '0';

	   constant CLK_period: time := 10 ns;
    begin
    
        --For designs with a CLK uncomment the following
            CLK_process : process
            begin
                CLK <= '0';
                wait for CLK_period/2;
                CLK <= '1'; 
                wait for CLK_period/2;
            end process;
    
    
        part : flags port map (
            FLG_C_SET   => FLG_C_SET  ,
            FLG_C_CLR   => FLG_C_CLR  ,
            FLG_C_LD    => FLG_C_LD   ,
            FLG_Z_LD    => FLG_Z_LD   ,
            FLG_LD_SEL  => FLG_LD_SEL ,
            FLG_SHAD_LD => FLG_SHAD_LD,
            CLK         => CLK        ,
            C           => C          ,
            Z           => Z          ,
            C_FLAG      => C_FLAG     ,
            Z_FLAG      => Z_FLAG     );
		
        stim_proc: process
        begin
    	    
    	    FLG_C_SET      <=  '1';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '0';
            FLG_Z_LD       <=  '0';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '0';
            Z              <=  '0';
            wait for 10 ns;
            
                	    
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '1';
            FLG_C_LD       <=  '0';
            FLG_Z_LD       <=  '0';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '1';
            Z              <=  '0';
            wait for 10 ns;
            
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '1';
            FLG_Z_LD       <=  '0';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '1';
            Z              <=  '0';
            wait for 10 ns;   
            
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '1';
            FLG_Z_LD       <=  '0';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '0';
            Z              <=  '0';
            wait for 10 ns;  
            
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '0';
            FLG_Z_LD       <=  '1';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '0';
            Z              <=  '1';
            wait for 10 ns; 
            
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '0';
            FLG_Z_LD       <=  '1';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '0';
            Z              <=  '0';
            wait for 10 ns;   
            
            FLG_C_SET      <=  '0';
            FLG_C_CLR      <=  '0';
            FLG_C_LD       <=  '0';
            FLG_Z_LD       <=  '0';
            FLG_LD_SEL     <=  '0';
            FLG_SHAD_LD    <=  '0';
            C              <=  '0';
            Z              <=  '0';
            wait for 10 ns;           
            
             wait;      
            
    

        end process;
end Behavioral;
