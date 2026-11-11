------------------------------------------------------------------------------
-- Design unit: BubbleSort
-- Description: BubbleSort structural architecture (Control path + Data path) 
--              BubbleSort behavioral architecture
------------------------------------------------------------------------------

library IEEE;                        
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.BubbleSort_pkg.all;

entity BubbleSort  is
    generic(
        ADDR_WIDTH  : integer := 8;
        DATA_WIDTH  : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        
        start       : in std_logic;
        startAddr   : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
        size        : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
        up          : in std_logic;    
        done        : out std_logic;
        
        -- Memory interface
        address     : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
        data_in     : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        data_out    : out std_logic_vector (DATA_WIDTH - 1 downto 0);
        ce          : out std_logic;
        wr          : out std_logic
    );
        
end BubbleSort;

architecture structural of BubbleSort is  
        
    signal cmd: Command;
    signal sts: Status;
    
begin

    CONTROL_PATH: entity work.ControlPath
        port map (
            clk     => clk,
            rst     => rst,
            start   => start,    
            done    => done,    
            wr      => wr,
            ce      => ce,
            cmd     => cmd,
            sts     => sts           
        );
        
    DATA_PATH: entity work.DataPath
        generic map (
            DATA_WIDTH  => DATA_WIDTH,
            ADDR_WIDTH  => ADDR_WIDTH
        )
        port map (
            clk         => clk,
            rst         => rst,
            startAddr   => startAddr,
            size        => size,
            cmd         => cmd,
            sts         => sts,
            data_in     => data_in,
            data_out    => data_out,
            address     => address,
            up          => up
        );
        
end structural;

architecture behavioral of BubbleSort is 

    type State is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal currentState: State;
    
    signal continue, swap, arrayEnd : std_logic;
    signal addr         : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    signal data0, data1 : UNSIGNED(DATA_WIDTH - 1 downto 0);
    
begin

    process(clk, rst)
    begin
    
        if rst = '1' then
            currentState <= S0;
            
        elsif rising_edge(clk) then
        
            case currentState is
                when S0 =>
                    continue <= '1';
                    
                    if start = '1' then
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;
                
                when S1 =>
                    addr <= UNSIGNED(startAddr);
                    continue <= '0';
                                       
                    if continue = '1' then
                        currentState <= S2;
                    else
                        currentState <= S7;
                    end if;
                
                when S2 =>
                    data0 <= UNSIGNED(data_in);                                        
                    currentState <= S3;
            
                when S3 =>
                    data1 <= UNSIGNED(data_in);                                                            
                    currentState <= S4;
                
                when S4 =>                
                    if swap = '1' then
                        continue <= '1';
                        currentState <= S5;
                    else
                        addr <= addr + 1;
                        currentState <= S6;
                    end if;
            
                when S5 => 
                    addr <= addr + 1;                    
                    currentState <= S6;
                
                when S6 =>
                    if arrayEnd = '1' then
                        currentState <= S1;
                    else
                        currentState <= S2;
                    end if;
                
                when S7 =>                    
                    currentState <= S0;
                
                when others =>
                    currentState <= S0;
            
            end case;
        end if;
    end process;
    
   
    swap        <= '1' when (data0 > data1 and up = '1') or (data0 < data1 and up = '0') else '0';
    data_out    <= STD_LOGIC_VECTOR(data0) when currentState = S4 else STD_LOGIC_VECTOR(data1);
    arrayEnd    <= '1' when (UNSIGNED(startAddr) + UNSIGNED(size)) = (addr + 1) else '0';
    wr          <= '1' when (currentState = S4 and swap = '1') or currentState = S5 else '0'; -- Memory write
    ce          <= '1' when currentState = S2 or currentState = S3 or (currentState = S4 and swap = '1') or currentState = S5 else '0';
    address     <= STD_LOGIC_VECTOR(addr) when currentState = S2 or currentState = S5 else STD_LOGIC_VECTOR(addr + 1);
    done        <= '1' when currentState = S7 else '0';
    
end behavioral;

