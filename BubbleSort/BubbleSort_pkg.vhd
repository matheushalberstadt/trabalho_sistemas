-------------------------------------------------------------------------
-- Design unit: BubleSort package
-- Description: Package with record grouping the interface between
--                  Control path and Data path
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package BubbleSort_pkg is

    type Command is record
        ldAddr      : std_logic;
        wrAddr      : std_logic;
        addrCtrl    : std_logic;
        dataOutCtrl : std_logic;
        wrData0     : std_logic;
        wrData1     : std_logic;
        setContinue : std_logic;
        rstContinue : std_logic;            
   end record;
   
   type Status is record
        continue    : std_logic;
        swap        : std_logic;
        arrayEnd    : std_logic;            
   end record;

end BubbleSort_pkg;