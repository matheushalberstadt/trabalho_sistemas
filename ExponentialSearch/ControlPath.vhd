library IEEE;
use IEEE.std_logic_1164.all;
use work.ExponentialSearch_pkg.all;

entity control_path is
    port ( 
        -- inputs
        data_av     : in std_logic;
        sts : in Status;
        ld_done: out std_logic;

        clk         : in std_logic;
        rst         : in std_logic;

        cmd : out Command;

        sel_mem : out std_logic;
        ld_mem : out std_logic

        
    );
end control_path;

architecture arch_control of control_path is

    type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);

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

    --Next state logic
    process(currentState, data_av, sts)
    begin

        case currentState is 
            when S0 =>
                if data_av = '1' then 
                    nextState <= S1;
                else nextState <= S0;
                end if;
            
            when S1 =>
                if data_av = '1' then 
                    nextState <= S2;
                else nextState <= S1;
                end if;
            
            when S2 => 
                if data_av = '1' then 
                     nextState <= S3;
                else nextState <= S2;
                end if;
            
            when S3 => 
                if sts.len_is_0 = '0' then   
                nextState <= S4;
                else 
                    nextState <= S15;
                end if;
            
            when S4 =>
                    if sts.eh_menor = '1' then
                    nextState <= S5;
                    else 
                        nextState <= S7;
                    end if;
            
            when S5 =>
                    nextState <= S6;
            
            when S6 =>
                    if sts.eh_menor = '0' then
                        nextState <= S7; 
                    else
                        nextState <= S4;
                    end if; 
            
            when S7 =>
                   nextState <= S8;
            
            when S8 =>
                nextState <= S9; 

            when S9 =>
                if sts.eh_menor = '1' or sts.eh_igual = '1' then 
                    nextState <= S10;
                elsif sts.eh_menor = '0' and sts.eh_igual = '0' then
                    nextState <= S15;
                end if;

            when S10 =>
                nextState <= S11;
            
            when S11 =>
                nextState <= S12;

            when S12 =>
                if sts.eh_menor = '1' then
                    nextState <= S13;
                elsif sts.eh_igual = '1' then
                    nextState <= S15;
                elsif (sts.eh_menor = '0' and sts.eh_igual = '0') then
                    nextState <= S14;
                end if;
            
            when S13 =>
                nextState <= S9;

            when S14 =>
                nextState <= S9;

            when S15 =>
                nextState <= S0;

            end case;

        end process;

    -- Output logic
    --Output 1
    cmd.ld_base             <= '1' when currentState = S0 and data_av = '1' else '0'; 
    cmd.ld_len              <= '1' when currentState = S1 and data_av = '1' else '0';
    cmd.ld_key              <= '1' when currentState = S2 and data_av = '1' else '0';
    sel_mem             <= '1' when currentState = S12 or currentState = S5 or currentState = S11 or currentState = S6 else '0';
    
    ld_mem              <= '0';

    cmd.ld_i                <= '1' when currentState = S3 or (currentState = S6 and sts.eh_menor = '1') else '0';
    cmd.ld_left             <= '1' when currentState = S7 or currentState = S13;
    cmd.ld_right            <= '1' when currentState = S7 or (currentState = S8 and sts.eh_menor = '1') or currentState = S14 else '0';
    cmd.ld_mid              <= '1' when currentState = S10;
    cmd.ld_pos              <= '1' when (currentState = S3 and sts.len_is_0= '1') or (currentState =S9 and sts.eh_menor = '0' and sts.eh_igual = '0')           or            (currentState= S12 and sts.eh_igual = '1') else '0';
    ld_done             <= '1' when currentState = S15;

    --Output 2
    cmd.sel_mux_pos         <= '1' when (currentState = S3 and sts.len_is_0 = '1') or (currentState = S9 and sts.eh_menor = '0' and sts.eh_igual = '0') else '0';
    cmd.sel_mux_i           <= '1' when currentState = S6 and sts.eh_menor = '1' else '0';
    cmd.sel_mux_right       <= '1' when currentState = S8 or currentState = S9;
    cmd.sub                 <= '1' when currentState = S4 or currentState = S7 or currentState = S6 or currentState = S8 or currentState = S9 or                        currentState = S12 or currentState = S14 else '0';

    cmd.sel_mux_0           <= '1' when currentState = S11 or currentState = S12 else '0';
    cmd.sel_mux_left        <= '1' when currentState = S13 else '0';
    cmd.sel_mux_1           <= "001" when currentState = S6 or currentState = S12 else
                           "010" when currentState = S7 else
                           "011" when currentState = S9 or currentState = S10 else
                           "100" when currentState = S13 or currentState = S14  else
                           "000";
    
    cmd.sel_mux_2           <= "01" when currentState = S6 or currentState = S12 else
                           "10" when currentState = S8 or currentState = S9 or currentState = S10 else
                           "11" when currentState = S7 or currentState = S13 or currentState = S14 else
                           "00";
    
    cmd.sub                 <= '1' when currentState = S4 or currentState = S6 or currentState = S7 or currentState = S8 or
                                    currentState = S9 or currentState = S12 or currentState = S14 else '0';

        
end arch_control;