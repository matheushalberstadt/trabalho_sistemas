library ieee;
use ieee.std_logic_1164.all;

entity muxNbits is
    generic(
        tam_sel     : INTEGER := 1;
        tam_dados   : INTEGER := 8
    );
    port(
        sel         : in STD_LOGIC_VECTOR(tam_sel - 1 downto 0);
        saida       : out STD_LOGIC_VECTOR(tam_dados - 1 downto 0);
        
    );
end muxNbits;