-------------------------------------------------------------------------
-- Design unit: BubbleSort test bench
-- Description: Tests both BubbleSort architectures
-------------------------------------------------------------------------

library IEEE;                        
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Test bench interface is always empty.
entity BubbleSort_tb  is
end BubbleSort_tb;


-- Instantiate the components and generates the stimuli.
architecture behavioral of BubbleSort_tb is  
    
    constant DATA_WIDTH     : integer := 12;
    constant ADDR_WIDTH     : integer := 5;
    
    signal rst, start       : std_logic; 
    signal size, startAddr  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal clk              : std_logic := '0';
    signal wr1, wr2         : std_logic;
    signal ce1, ce2         : std_logic;
    signal up               : std_logic;
    signal done1, done2     : std_logic;
    signal address1, address2    : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal bs1_data_in, bs1_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal bs2_data_in, bs2_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);    

begin

    -- Instantiates the units under test.
    PROCESSOR_BEH: entity work.BubbleSort(behavioral) 
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH
        )
        port map (
            clk         => clk,
            rst         => rst,
            start       => start,
            done        => done1,
            startAddr   => startAddr,
            size        => size,
            up          => up,
            
            -- Memory interface
            ce          => ce1,
            wr          => wr1,
            data_in     => bs1_data_in,
            data_out    => bs1_data_out,
            address     => address1
        );
        
    RAM1: entity work.Memory
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH,
            imageFileName => "image.txt"
        )
        port map (
            clk         => clk,
            ce          => ce1,
            wr          => wr1,
            data_in     => bs1_data_out,
            data_out    => bs1_data_in,
            address     => address1
        );
        
    -- Instantiates the units under test.
    PROCESSOR_STR: entity work.BubbleSort(structural) 
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH
        )
        port map (
            clk         => clk,
            rst         => rst,
            start       => start,
            startAddr   => startAddr,
            size        => size,
            up          => up,
            done        => done2,
            
            -- Memory interface
            wr          => wr2,
            ce          => ce2,
            data_in     => bs2_data_in,
            data_out    => bs2_data_out,
            address     => address2
        );
        
    RAM2: entity work.Memory
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH,
            imageFileName   => "image.txt"
        )
        port map (
            clk       => clk,
            ce          => ce2,
            wr          => wr2,
            data_in     => bs2_data_out,
            data_out    => bs2_data_in,
            address     => address2
        );
        
    -- Generates the stimuli.
    rst <= '0', '1' after 10 ns, '0' after 15 ns;
    clk <= not clk after 20 ns;    -- 25 MHz
    
    process
    begin
        start <= '0';
        up <= '1';
               
        wait until  clk = '1';
        wait until  clk = '1';
            start<= '1';
            startAddr <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_WIDTH));
            size <= STD_LOGIC_VECTOR(TO_UNSIGNED(11,ADDR_WIDTH));
        
        wait until clk = '1';
            start <= '0';
            
        wait until done1 = '1' or done2 = '1';
        wait until done1 = '0' or done2 = '0';
            up <= '0';
            start<= '1';
            
        wait until clk = '1';
            start <= '0';
            
        wait;    -- Suspend process          
               
       end process;
       

end behavioral;


