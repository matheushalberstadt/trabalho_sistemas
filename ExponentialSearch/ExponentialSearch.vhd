library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ExponentialSearch_pkg.all;

entity ExponentialSearch is
    generic (
        WIDTH : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;

        data        : in std_logic_vector (WIDTH - 1 downto 0);
        data_av     : in std_logic;
        pos         : out std_logic_vector (WIDTH - 1 downto 0);
        done        : out std_logic;

        -- Memoria
        address     : out std_logic_vector (WIDTH - 1 downto 0);
        data_in     : in std_logic_vector (WIDTH - 1 downto 0);
        data_out    : out std_logic_vector (WIDTH - 1 downto 0);
        sel_mem     : out std_logic;
        ld_mem      : out std_logic 
    );
end ExponentialSearch;

architecture estrutural of ExponentialSearch is
    signal cmd : Command;
    signal sts : Status;

begin
    CONTROL_PATH : entity work.control_path
        port map (
            clk => clk,
            rst => rst,
            data_av => data_av,
            done => done,
            sts => sts,
            cmd => cmd, 
            sel_mem => sel_mem,
            ld_mem => ld_mem
        );

    DATA_PATH : entity work.data_path
        generic map  (
            WIDTH => WIDTH
        )
        port map (
            clk => clk,
            rst => rst,
            data => data,
            pos => pos,
            sts => sts,
            cmd => cmd,
            address => address,
            data_in     => data_in,
            data_out    => data_out
        );
end estrutural;

architecture  comportamental of ExponentialSearch is
    type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);
    signal currentState : State;
    signal base, len, key, i, left, right, mid, posReg : UNSIGNED(WIDTH - 1 downto 0);

begin   
    process (clk, rst)
    begin
        if rst = '1' then
            currentState <= S0;
            base    <= (others => '0');
            len     <= (others => '0');
            key     <= (others => '0');
            i       <= (others => '0');
            left    <= (others => '0');
            right   <= (others => '0');
            mid     <= (others => '0');
            posReg  <= (others => '0');
        
        elsif rising_edge(clk) then
            case currentState is
                when S0 =>
                    if data_av = '1' then
                        base <= UNSIGNED(data);
                        currentState <= S1;
                    end if;

                when S1 =>
                    if data_av = '1' then
                        len <= UNSIGNED(data);
                        currentState <= S2;
                    end if;

                when S2 =>
                    if data_av = '1' then
                        key <= UNSIGNED(data);
                        currentState S3;
                    end if;

                when S3 =>
                    i <= TO_UNSIGNED(1, WIDTH);
                    if len = '0' then 
                        posReg <= (others => '1'); 
                        currentState <= S15;
                    else 
                        currentState <= S4;
                    end if;

                when S4 =>
                    if i < len then
                        currentState <= S5;
                    else
                        currentState <= S7;
                    end if;

                when S5 =>
                    currentState <= S6;

                when S6 =>
                    if SIGNED(data_in) < SIGNED(key) then
                        i <= i(WIDTH - 2 downto 0) & '0'; -- i *= 2
                        currentState <= S4;
                    else
                        currentState <= S7;
                    end if;

                when S7 =>
                    left  <= '0' & i(WIDTH - 1 downto 1);  -- left = i / 2
                    right <= len - 1;
                    currentState <= S8;

                when S8 =>
                    if i < right then
                        right <= i; 
                    end if;
                    currentState <= S9;

                when S9 =>
                    if left <= right then
                        currentState <= S10;
                    else 
                        posReg <= (others => '1');
                        currentState <= S15;
                    end if;

                when S10 =>
                    mid <= '0' & std_logic_vector(left + right)(WIDTH - 1 downto 1); -- mid = (left+right)/2
                    currentState <= S11;

                when S11 =>
                    currentState <= S12;

                when S12 =>
                    if UNSIGNED(data_in) = key then
                        posReg <= mid;              -- encontrou
                        currentState <= S15;
                    elsif SIGNED(data_in) < SIGNED(key) then
                        currentState <= S13;
                    else 
                        currentState <= S14;
                    end if;

                when S13 =>
                    left <= mid + '1';
                    currentState <= S9;

                when S14 =>
                    right <= mid - '1';
                    currentState <= S9;

                when S15 =>
                    currentState <= S0;

                when others =>
                    currentState <= S0;
            
            end case;
        end if;
    end process;

    pos         <= STD_LOGIC_VECTOR(posReg);
    done        <= '1' when currentState = S15 else '0';

    address     <= STD_LOGIC_VECTOR(base + mid) when currentState = S11 or currentState = S12 else STD_LOGIC_VECTOR(base + i);
    sel_mem     <= '1' when currentState = S5 or currentState = S6 or currentState = S11 or currentState = S12 else '0';
    ld_mem      <= '0';
    data_out    <= (others => '0');

end comportamental;