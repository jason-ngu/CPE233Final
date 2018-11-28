----------------------------------------------------------------------------------
-- Engineer: Bridget Benson
-- Create Date: 09/21/2015 09:02:18 AM
-- Description: Template file for test benches
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--make the entity name of your simulation file the same name as the file you  wish to simulate
--with the word Sim at the end of it.  The entity is empty because a simulation file does not 
--connect to anything on the board.
entity simulation is
--  Port ( );
end simulation;

architecture Behavioral of simulation is

component rat_mcu_wrapper is
    Port ( SWITCHES : in STD_LOGIC_VECTOR (7 downto 0);
           PMOD : in STD_LOGIC_VECTOR (7 downto 0);
           BTNR : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           CLK : in STD_LOGIC;
           LEDS : out STD_LOGIC_VECTOR (15 downto 0);
           ANODES : out STD_LOGIC_VECTOR (3 downto 0);
           CATHODES : out STD_LOGIC_VECTOR (7 downto 0)
           );
end component rat_mcu_wrapper;
    

    
	signal CLK : std_logic := '0';
	
	constant CLK_period: time := 10 ns;
	
	signal SWITCHES  : STD_LOGIC_VECTOR (7 downto 0);
	signal PMOD  : STD_LOGIC_VECTOR (7 downto 0);
    signal BTNR    : std_logic;
    signal BTNL      : std_logic;
    signal LEDS : STD_LOGIC_VECTOR (15 downto 0);
    signal ANODES : STD_LOGIC_VECTOR (3 downto 0);
    signal CATHODES : STD_LOGIC_VECTOR (7 downto 0);
    begin
        
        processor : rat_mcu_wrapper port map(
            SWITCHES  => SWITCHES ,
            PMOD      => PMOD     ,
            BTNR      => BTNR     ,
            BTNL      => BTNL     ,
            CLK       => CLK      ,
            LEDS      => LEDS     ,
            ANODES    => ANODES   ,    
            CATHODES  => CATHODES
        );
		--For designs with a CLK uncomment the following
		CLK_process : process
		begin
			CLK <= '0';
			wait for CLK_period/2;
			CLK <= '1'; 
			wait for CLK_period/2;
		end process;
		
		
        stim_proc: process
        begin
            BTNR <= '1';
            BTNL <= '0';
            SWITCHES <= "00011010";
            PMOD <= "00000001";
            wait for 10 ns;
            BTNR <= '0';
            wait;
        end process;
end Behavioral;
