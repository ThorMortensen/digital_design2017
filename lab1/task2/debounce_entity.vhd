LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_misc.all;

ENTITY debounce IS
    PORT ( clk:			IN  STD_LOGIC;
           reset:		IN  STD_LOGIC;
           sw:			IN  STD_LOGIC;
           db_level:	OUT  STD_LOGIC;
           db_tick :	OUT  STD_LOGIC);
END debounce;
