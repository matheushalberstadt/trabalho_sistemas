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
    signal saida_base, saida_len, saida_key, saida_left, saida_i, saida_mid, saida_right             : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal saida_mux_pos, saida_mux_right, saida_mux_left, saida_mux_2, saida_mux_i, saida_mux_0, saida_mux_1                                       : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal saida_adder2, xorInversor                                 : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal carry_out_n_existe                           : STD_LOGIC;
begin
    --Registradores
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
            d     => saida_mux_pos,
            q     => pos
        );

    reg_right:  entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_right,
            d     => saida_mux_right,
            q     => saida_right
        );
    
    reg_mid:    entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_mid,
            d     => '0' & saida_adder2(WIDTH - 1 downto 1), --Divisao da saida do adder2 por 2
            q     => saida_mid
        );
    
    
    reg_left:   entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_left,
            d     => saida_mux_left,
            q     => saida_left
        );
    reg_I:      entity work.RegisterNbits
        generic map(WIDTH => WIDTH)
        port map(
            clock => clk,
            reset => rst,
            ce    => cmd.ld_i,
            d     => saida_mux_i,
            q     => saida_i
        );

    --Somadores
    adder1:     entity work.adderNbits
        generic map(n => WIDTH)
        port map(
            A       => saida_base,
            B       => saida_mux_0,
            CarryIn       => '0',
            CarryOut      => carry_out_n_existe,
            Sum       => address
        );

    adder2:     entity work.adderNbits
        generic map(n => WIDTH)
        port map(
            A       => saida_mux_1,
            B       => xorInversor,
            CarryIn      => cmd.sub,
            CarryOut      => carry_out_n_existe,
            Sum       => saida_adder2
        );

    --Muxes
    saida_mux_1 <= saida_I      when cmd.sel_mux_1 = "000" else
                  data_in       when cmd.sel_mux_1 = "001" else
                  saida_len     when cmd.sel_mux_1 = "010" else
                  saida_left    when cmd.sel_mux_1 = "011" else
                  saida_mid     when cmd.sel_mux_1 = "100" else  
                  (others => '0');

    saida_mux_2 <= saida_len    when cmd.sel_mux_2 = "00" else
                   saida_key    when cmd.sel_mux_2 = "01" else
                   saida_right  when cmd.sel_mux_2 = "10" else
                   (0 => '1', others => '0');
    saida_mux_0 <= saida_i      when cmd.sel_mux_0 = '0' else
                   saida_mid;   

    
end structural;