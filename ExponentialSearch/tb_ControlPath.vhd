library ieee;
use ieee.std_logic_1164.all;
use work.ExponentialSearch_pkg.all;

entity tbControlPath is
end tbControlPath;

architecture tb of tbControlPath is

    signal clk      : std_logic := '0';
    signal rst      : std_logic;
    signal data_av  : std_logic;
    signal sts      : Status;
    signal cmd      : Command;
    signal done  : std_logic;
    signal sel_mem  : std_logic;
    signal ld_mem   : std_logic;

begin

    UUT: entity work.control_path
        port map (
            data_av => data_av,
            sts     => sts,
            done    => done,
            clk     => clk,
            rst     => rst,
            cmd     => cmd,
            sel_mem => sel_mem,
            ld_mem  => ld_mem
        );

    clk <= not clk after 10 ns;     -- periodo de 20 ns
    rst <= '1', '0' after 15 ns;

    -- Os status sao trocados na borda de descida, para estarem estaveis
    -- na borda de subida em que o controle decide o proximo estado.
    -- O comentario de cada passo indica o estado atual -> proximo estado.
    process
        -- Espera n bordas de descida (n ciclos de clock)
        procedure ciclos(n : integer) is
        begin
            for i in 1 to n loop
                wait until falling_edge(clk);
            end loop;
        end procedure;
    begin
        data_av      <= '0';
        sts.len_is_0 <= '0';
        sts.eh_menor <= '0';
        sts.eh_igual <= '0';
        wait until rst = '0';
        ciclos(1);

        ----------------------------------------------------------------
        -- Teste 1: leitura das entradas e len = 0
        ----------------------------------------------------------------
        ciclos(2);                              -- S0 -> S0 (data_av = 0)
        data_av <= '1';      ciclos(1);         -- S0 -> S1
        data_av <= '0';      ciclos(2);         -- S1 -> S1 (data_av = 0)
        data_av <= '1';      ciclos(1);         -- S1 -> S2
        data_av <= '0';      ciclos(1);         -- S2 -> S2 (data_av = 0)
        data_av <= '1';      ciclos(1);         -- S2 -> S3
        data_av <= '0';
        sts.len_is_0 <= '1'; ciclos(1);         -- S3 -> S15
        sts.len_is_0 <= '0'; ciclos(1);         -- S15 -> S0

        ----------------------------------------------------------------
        -- Teste 2: laco exponencial e laco da busca binaria
        ----------------------------------------------------------------
        data_av <= '1';      ciclos(3);         -- S0 -> S1 -> S2 -> S3
        data_av <= '0';      ciclos(1);         -- S3 -> S4 (len_is_0 = 0)
        sts.eh_menor <= '1'; ciclos(1);         -- S4 -> S5
                             ciclos(1);         -- S5 -> S6
        sts.eh_menor <= '1'; ciclos(1);         -- S6 -> S4 (continua dobrando i)
        sts.eh_menor <= '1'; ciclos(2);         -- S4 -> S5 -> S6
        sts.eh_menor <= '0'; ciclos(1);         -- S6 -> S7 (sai do laco)
                             ciclos(2);         -- S7 -> S8 -> S9
        sts.eh_menor <= '1'; ciclos(3);         -- S9 -> S10 -> S11 -> S12
        sts.eh_menor <= '1'; ciclos(1);         -- S12 -> S13
                             ciclos(1);         -- S13 -> S9
        sts.eh_menor <= '0';
        sts.eh_igual <= '1'; ciclos(3);         -- S9 -> S10 -> S11 -> S12
        sts.eh_igual <= '0';
        sts.eh_menor <= '0'; ciclos(1);         -- S12 -> S14
                             ciclos(1);         -- S14 -> S9
        sts.eh_menor <= '1'; ciclos(3);         -- S9 -> S10 -> S11 -> S12
        sts.eh_menor <= '0';
        sts.eh_igual <= '1'; ciclos(1);         -- S12 -> S15 (achou a chave)
        sts.eh_igual <= '0'; ciclos(1);         -- S15 -> S0

        ----------------------------------------------------------------
        -- Teste 3: S4 direto para S7 e S9 terminando sem achar a chave
        ----------------------------------------------------------------
        data_av <= '1';      ciclos(3);         -- S0 -> S1 -> S2 -> S3
        data_av <= '0';      ciclos(1);         -- S3 -> S4
        sts.eh_menor <= '0'; ciclos(1);         -- S4 -> S7
                             ciclos(2);         -- S7 -> S8 -> S9
        sts.eh_menor <= '0';
        sts.eh_igual <= '0'; ciclos(1);         -- S9 -> S15 (nao achou)
                             ciclos(1);         -- S15 -> S0

        ciclos(2);
        report "Fim da simulacao" severity note;
        wait;
    end process;

end tb;
