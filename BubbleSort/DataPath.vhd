-------------------------------------------------------------------------
-- Design unit: DataPath
-- Description: Bubble sort data path
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BubbleSort_pkg.all;

entity DataPath is
    generic (
        DATA_WIDTH  : integer := 16;
        ADDR_WIDTH  : integer := 16
    );
    port (  
        clk         : in std_logic;
        rst         : in std_logic;
        startAddr   : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
        size        : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
        up          : in std_logic;
        
        -- Control path interface
        sts         : out Status;
        cmd         : in Command;
        
        -- Memory interface
        address     : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
        data_in      : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        data_out     : out std_logic_vector (DATA_WIDTH - 1 downto 0)
    );
end DataPath;


architecture behavioral of DataPath is

    signal inAddr, addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal incAddr      : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    signal data0, data1 : std_logic_vector(DATA_WIDTH - 1 downto 0);
    
begin

    REG_ADDR0: entity work.RegisterNbits
        generic map (
            WIDTH   => ADDR_WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.wrAddr,
            d       => inAddr,
            q       => addr            
        );
        
    incAddr     <= UNSIGNED(addr) + 1;    
    inAddr      <= startAddr when cmd.ldAddr = '1' else STD_LOGIC_VECTOR(incAddr);
    address     <= STD_LOGIC_VECTOR(incAddr) when cmd.addrCtrl = '1' else addr;
    sts.arrayEnd    <= '1' when (UNSIGNED(startAddr) + UNSIGNED(size)) = incAddr else '0';
    
    
    REG_DATA0: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.wrData0,
            d       => data_in,
            q       => data0            
        );
        
    REG_DATA1: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.wrData1,
            d       => data_in,
            q       => data1            
        );
        
        
    data_out <= data1 when cmd.dataOutCtrl = '1' else data0;
    sts.swap <= '1' when (UNSIGNED(data0) > UNSIGNED(data1) and up = '1') or (UNSIGNED(data0) < UNSIGNED(data1) and up = '0') else '0';
  
    FF_CONTINUE: process(clk)
        begin
            if rising_edge(clk) then
                if cmd.setContinue = '1' then
                    sts.continue <= '1';
                elsif cmd.rstContinue = '1' then
                    sts.continue <= '0';
                end if;
            end if;
        end process;

        
end behavioral;
