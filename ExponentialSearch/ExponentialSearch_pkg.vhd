
library IEEE;
use IEEE.std_logic_1164.all;

package ExponentialSearch_pkg is

    type Command is record
        --Bloco Operativo
        ld_base         : std_logic;
        ld_len          : std_logic;
        ld_key          : std_logic;
        ld_i            : std_logic;
        ld_left         : std_logic;
        ld_right        : std_logic;
        ld_mid          : std_logic;
        ld_pos          : std_logic;
        sel_mux_i       : std_logic;                  
        sel_mux_right   : std_logic;                     
        sel_mux_left    : std_logic;                     
        sel_mux_pos     : std_logic;                     
        sel_mux_0       : std_logic;              
        sel_mux_1       : std_logic_vector(2 downto 0);  
        sel_mux_2       : std_logic_vector(1 downto 0);  
        sub             : std_logic;                    
    end record;

    type Status is record --Bloco de Controle
        len_is_0        : std_logic;
        eh_menor        : std_logic;    
        eh_igual        : std_logic;    
    end record;

end ExponentialSearch_pkg;