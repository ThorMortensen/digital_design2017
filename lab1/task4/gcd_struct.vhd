
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FSM IS
    PORT (clk       : in std_logic;           -- The clock signal.
          reset     : in std_logic;           -- RESET the module.
          ------------------------------------------------------------------------
          ABorALU  : out std_logic;  
          LDA      : out std_logic;  
          LDB      : out std_logic;  
          FN       : out std_logic;  
          Z        : out std_logic;  
          N        : out std_logic(1 downto 0));  
END FSM;


TYPE state_type IS (IDLE, LOAD_A, LOAD_B, CALC); -- Input your own state names

SIGNAL reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0) := (others => '0');
SIGNAL state, next_state : state_type := IDLE;

BEGIN


process(state, req, n, z)

begin


end process;



state_reg: process(clk)
begin
  if rising_edge(clk) then 
    if reset = '1' then
      state <= IDLE;
    else 
      state <= next_state;
    end if;
  end if;
end process state_reg;



ARCHITECTURE behaviour OF FSM IS









END behaviour;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY data_path IS
    PORT (clk:   IN std_logic;           -- The clock signal.
          reset: IN std_logic;           -- RESET the module.
          req:   IN std_logic;           -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);  -- The two operands.
          ack:   OUT std_logic;          -- Computation is complete.
          C:     OUT unsigned(15 downto 0));  -- The result.
END data_path;

ARCHITECTURE behaviour OF data_path IS


ENTITY gcd IS
    PORT (clk:   IN std_logic;           -- The clock signal.
          reset: IN std_logic;           -- RESET the module.
          req:   IN std_logic;           -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);  -- The two operands.
          ack:   OUT std_logic;          -- Computation is complete.
          C:     OUT unsigned(15 downto 0));  -- The result.
END gcd;




    COMPONENT gcd
        PORT (clk   : IN std_logic;       -- The clock signal.
              reset : IN std_logic;           -- Reset the module.
              req   : IN std_logic;       -- Input operand / Start computation.
              AB    : IN unsigned(15 downto 0); -- Bus for A and B operands.
              ack   : OUT std_logic;        -- Input received / Computation is complete.
              C   : OUT unsigned(15 downto 0)     -- The result.
             );
    END COMPONENT;



BEGIN


FSM_inst : entity work.FSM port map(
   a => a,
   b => b,
   sum => s1,
   carry => c1
   );


END behaviour;