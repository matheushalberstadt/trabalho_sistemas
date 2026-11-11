library IEEE;
use IEEE.std_logic_1164.all;
use work.ExponentialSearch_pkg.all;

entity data_path is 
    generic(
        WIDTH               : INTEGER := 8
    );
    port(
        clk                 : in STD_LOGIC;
        rst                 : in std_logic;
        data                : in STD_LOGIC_VECTOR(width - 1 downto 0);
        pos                 : out std_logic_vector(WIDTH-1 downto 0);

        data_in             : in std_logic_vector(width - 1 downto 0);
        data_out            : out std_logic_vector(width - 1 downto 0);
        address             : out std_logic_vector(width - 1 downto 0);

        sts                 : out Status;
        cmd                 : in Command
    );
end data_path;

architecture structural of data_path is
    signal saida_base, saida_len, saida_key               : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal mux_pos, mux_right, mux_2                                        : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal adder1, adder2                                 : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);

begin
    reg_base:   entity work.RegisterNbits
        generic map (
            WIDTH => WIDTH
        )
        port map (
            clock => clk,
            reset => rst,
            ce    => cmd.ld_base,
            d     => data,
            q     => saida_base
        );

    reg_len:    entity work.RegisterNbits
        generic map (WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_len,
            d     => data,
            q     => saida_len
        );

    reg_key:    entity work.RegisterNbits
        generic map (WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_key,
            d     => data,
            q     => saida_key
        );
    
    reg_pos:    entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_pos,
            d     => mux_pos,
            q     => pos
        );

    reg_right:    entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_right,
            d     => mux_right,
            q     => mux_2
        );
    
    reg_mid:    entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_mid,
            d     => '0' & adder2(WIDTH - 1 downto 1), --Divisao por 2
            q     => pos
        );
    

end structural;