-------------------------------------------------------------------------
-- Design unit: Controlpath
-- Description: Control path FSM in three parts
--                  1) State memory
--                  2) Next state logic
--                  3) Output logic 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.BubbleSort_pkg.all;

entity ControlPath is
    port (  
        clk         : in std_logic;
        rst         : in std_logic;
        
        start       : in std_logic;
        done        : out std_logic;
        
        -- Data path interface
        sts         : in Status;
        cmd         : out Command;
        
        -- Memory interface
        ce          : out std_logic;
        wr          : out std_logic             
    );
end ControlPath;
                   

architecture behavioral of ControlPath is  
        
    type State is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal currentState, nextState : State;
    
begin
    
    -- State memory
    process(clk, rst)
    begin
        
        if rst = '1' then
            currentState <= S0;
        
        elsif rising_edge(clk) then
            currentState <= nextState;
            
        end if;
    end process;
    
    -- Next state logic
    process(currentState, sts.swap, start, sts.arrayEnd, sts.continue)
    begin
        
        case currentState is
            when S0 =>
                if start = '1' then
                    nextState <= S1;
                else
                    nextState <= S0;
                end if;
                
            when S1 =>
                if sts.continue = '1' then
                    nextState <= S2;
                else
                    nextState <= S7;
                end if;
                
            when S2 =>
                nextState <= S3;
            
            when S3 =>
                nextState <= S4;
                
            when S4 =>
                if sts.swap = '1' then
                    nextState <= S5;
                else 
                    nextState <= S6;
                end if;
            
            when S5 => 
                nextState <= S6;
                
            when S6 =>
                if sts.arrayEnd = '1' then
                    nextState <= S1;
                else
                    nextState <= S2;
                end if;
                
            when S7 =>
                nextState <= S0;
                
            when others =>
                nextState <= S0;
            
        end case;
        
    end process;
    
    -- Output logic
    done            <= '1' when currentState = S7 else '0';
    wr              <= '1' when (currentState = S4 and sts.swap = '1') or currentState = S5 else '0'; -- Memory write (wr = 1)
    ce              <= '1' when currentState = S2 or currentState = S3 or (currentState = S4 and sts.swap = '1') or currentState = S5 else '0';
    cmd.ldAddr      <= '1' when currentState = S1 else '0';
    cmd.wrAddr      <= '1' when currentState = S1 or (currentState = S4 and sts.swap = '0') or currentState = S5 else '0';
    cmd.addrCtrl    <= '1' when currentState = S3 or currentState = S5 else '0';
    cmd.dataOutCtrl <= '1' when currentState = S4 else '0';
    cmd.wrData0     <= '1' when currentState = S2 else '0';
    cmd.wrData1     <= '1' when currentState = S3 else '0';  
    cmd.setContinue <= '1' when (currentState = S4 and sts.swap = '1') or currentState = S0 else '0';
    cmd.rstContinue <= '1' when currentState = S1 else '0';
      
end behavioral;
