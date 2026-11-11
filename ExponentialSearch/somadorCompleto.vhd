
library ieee;
use ieee.std_logic_1164.all;

entity somadorCompleto is
    port (
        --Entradas
        A, B, Ci : in  std_logic;
        --Saidas
        S, Co     : out std_logic

    );
end somadorCompleto;


architecture arch1 of somadorCompleto is
    signal a_xor_b, a_and_b, a_xor_b_and_Ci : std_logic;

begin 
    --Generate sum (S)
    a_xor_b <= A xor B;
    S <= a_xor_b xor Ci;

    --Gerar carry out (Co)
    a_xor_b_and_Ci <= a_xor_b and Ci;
    a_and_b <= A and B;
    Co <= a_and_b or a_xor_b_and_Ci;

end arch1;
