library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adderNbits is 
    generic (
        n               : integer := 8 --n bits
    );
    port(
        A, B            : in std_logic_vector(n-1 downto 0);
        CarryIn         : in std_logic;

        Sum             : out std_logic_vector(n-1 downto 0);
        CarryOut        : out std_logic
    );
    end adderNbits;

architecture estrutura_generica of adderNbits is 
    signal Carry:       std_logic_vector(n downto 0);
begin
    Carry(0)    <= CarryIn;
    CarryOut    <= Carry(n);
    
    AdderBit:       for i in a'range generate
        FullAdder: entity work.somadorCompleto(arch1) port map(
            A               => A(i),
            B               => B(i),
            Ci              => Carry(i),
            S               => Sum(i),
            Co              => Carry(i+1)
        );
        end generate;
end estrutura_generica;

architecture comportamental_generica of adderNbits is
    signal a_ext, b_ext, sum_ext : std_logic_vector(A'left + 1 downto 0);
begin
    -- Extends the inputs in 1 bit
    a_ext <= '0' & A;
    b_ext <= '0' & B;
    -- Generates the sum
    sum_ext <= a_ext + b_ext + CarryIn;
    -- Outputs the carry out
    CarryOut <= sum_ext(sum_ext'left);
    -- Outputs only 8 bits
    Sum <= sum_ext(Sum'range);
end comportamental_generica;