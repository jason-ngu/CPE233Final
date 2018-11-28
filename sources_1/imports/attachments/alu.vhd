library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port ( SEL : in std_logic_vector(3 downto 0);
             A : in std_logic_vector(7 downto 0);
             B : in std_logic_vector(7 downto 0);
           CIN : in std_logic;
        RESULT : out std_logic_vector(7 downto 0);
             C : out std_logic;
             Z : out std_logic);
end entity alu;


architecture Behavioral of alu is

signal carryresult : std_logic_vector(8 downto 0);
signal CINv : std_logic_vector(7 downto 0);

begin

RESULT <= carryresult(7 downto 0);
C <= carryresult(8);
CINv(0) <= CIN;
CINv(7 downto 1) <= "0000000";

main: process(carryresult, SEL, A, B, CIN, CINv)
begin
    if carryresult(7 downto 0) = "00000000" and SEL /= "0100" and SEL /= "1000" then
        Z <= '1';
    elsif SEL = "0100" then --cmp
        if  (signed('0' & A) - signed('0' & B)) = 0 then
            Z <= '1';
        else
            Z <= '0';
        end if;
    elsif SEL = "1000" then --test
        if (A and B) = "11111111" then
            Z <= '1';
        else
            Z <= '0';
        end if;
    else
        Z <= '0';
    end if;
    
    case SEL is
        when "0000" => carryresult <= std_logic_vector(signed('0' & A) + signed('0' & B));
        when "0001" => carryresult <= std_logic_vector(signed('0' & A) + signed('0' & B) + signed('0' & CINv));
        when "0010" => carryresult <= std_logic_vector(signed('0' & A)- signed('0' & B));
        when "0011" => carryresult <= std_logic_vector(signed('0' & A) - signed('0' & B) - signed('0' & CINv));
        when "0100" => 
                if  (signed('0' & A) - signed('0' & B)) < 0 then
                    carryresult(8) <= '1';
                else
                    carryresult(8) <= '0';
                end if;
                carryresult(7 downto 0) <= A;
        when "0101" =>
                carryresult(7 downto 0) <= A AND B;
                carryresult(8) <= Cin;
        when "0110" =>
                carryresult(7 downto 0) <= A OR B; 
                carryresult(8) <= Cin;
        when "0111" => 
            carryresult(7 downto 0) <= A XOR B;
            carryresult(8) <= Cin;
        when "1000" =>
            carryresult(7 downto 0) <= A;
            carryresult(8) <= '0';
        when "1001" =>
            carryresult(8 downto 1) <= A(7 downto 0);
            carryresult(0) <= CIN;
        when "1010" =>
            carryresult(8) <= A(0);
            carryresult(7) <= CIN;
            carryresult(6 downto 0) <= A(7 downto 1);
        when "1011" =>
            carryresult(8 downto 1) <= A;
            carryresult(0) <= A(7);
        when "1100" =>
            carryresult(6 downto 0) <= A(7 downto 1);
            carryresult(8) <= A(0);
            carryresult(7) <= A(0); 
        when "1101" => 
            carryresult(8) <= A(0);
            carryresult(7) <= A(7);
            carryresult(6 downto 0) <= A(7 downto 1);
        when "1110" =>
            carryresult(7 downto 0) <= B;
            carryresult(8) <= CIN;
        when others =>
            carryresult(7 downto 0) <= A;
            carryresult(8) <= CIN;
        end case;
        
        --if SEL = "0000" then --add
        --    carryresult <= std_logic_vector(signed('0' & B) + signed('0' & A)); 
        --elsif SEL = "0001" then --addc
        --    carryresult <= std_logic_vector(signed('0' & B) + signed('0' & A) + signed('0' & CINv));
        --elsif SEL = "0010" then --sub
        --    carryresult <= std_logic_vector(signed('0' & B)- signed('0' & A)); 
        --elsif SEL = "0011" then --subc
        --    carryresult <= std_logic_vector(signed('0' & B) - signed('0' & A) - signed('0' & CINv));
        --elsif SEL = "0100" then --CMP
        --    if  (signed('0' & B) - signed('0' & A)) < 0 then
        --        carryresult(8) <= '1';
        --    else
        --        carryresult(8) <= '0';
        --    end if;
        --    carryresult(7 downto 0) <= A;
        --elsif SEL = "0101" then --and
        --    carryresult(7 downto 0) <= A AND B;
        --    carryresult(8) <= Cin;
        --elsif SEL = "0110" then --or
        --    carryresult(7 downto 0) <= A OR B; 
        --    carryresult(8) <= Cin;
        --elsif SEL = "0111" then --exor
        --    carryresult(7 downto 0) <= A XOR B;
        --    carryresult(8) <= Cin;
        --elsif SEL = "1000" then --test
        --    carryresult(7 downto 0) <= A;
        --    carryresult(8) <= '0';
        --elsif SEL = "1001" then --lsl
        --    carryresult(8 downto 1) <= A(7 downto 0);
        --    carryresult(0) <= CIN;
        --elsif SEL = "1010" then --lsr
        --    carryresult(8) <= A(0);
        --    carryresult(7) <= CIN;
        --    carryresult(6 downto 0) <= A(7 downto 1);
        --elsif SEL = "1011" then --rol
        --    carryresult(8 downto 1) <= A;
        --    carryresult(0) <= A(7);
        --elsif SEL = "1100" then --ror
        --    carryresult(6 downto 0) <= A(7 downto 1);
        --    carryresult(8) <= A(0);
        --    carryresult(7) <= A(0); 
        --elsif SEL = "1101" then --asr
        --    carryresult(8) <= A(0);
        --    carryresult(7) <= A(7);
        --    carryresult(6 downto 0) <= A(7 downto 1);
        --elsif SEL = "1110" then --mov
        --    carryresult(7 downto 0) <= B;
        --    carryresult(8) <= CIN;
        --else 
        --    carryresult(7 downto 0) <= A;
        --    carryresult(8) <= CIN;
        --end if;
    
end process main;

end Behavioral;
