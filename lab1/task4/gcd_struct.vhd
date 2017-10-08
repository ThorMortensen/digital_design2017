
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FSM IS
    PORT (clk       : in std_logic;           -- The clock signal.
          reset     : in std_logic;           -- RESET the module.
          ----------------------------------------------------------------------
          req       : in std_logic;
          ack       : out std_logic;
          ------------------------------------------------------------------------
          ABorALU   : out std_logic;  
          LDA       : out std_logic;  
          LDB       : out std_logic;  
          alu_Z     : out std_logic;  
          alu_N     : out std_logic;
          alu_FN    : out std_logic_vector(1 downto 0));  
END FSM;


ARCHITECTURE behaviour OF FSM IS

TYPE state_type IS (IDLE, SETUP, LOAD_A, ACK_STATE, LOAD_B, CALC); -- Input your own state names

signal state    : state_type := IDLE;
signal next_state    : state_type := IDLE;

BEGIN


CL : process(state, req, alu_Z, alu_N)
begin


end process CL;



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









END behaviour;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


-- Data path 
ENTITY gcd IS
    PORT (clk:   IN std_logic;           -- The clock signal.
          reset: IN std_logic;           -- RESET the module.
          req:   IN std_logic;           -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);  -- The two operands.
          ack:   OUT std_logic;          -- Computation is complete.
          C:     OUT unsigned(15 downto 0));  -- The result.
END gcd;

ARCHITECTURE behaviour OF gcd IS

  constant DATA_WIDTH : NATURAL := 16; 

  signal ABorALU   : std_logic := '0';  
  signal LDA       : std_logic := '0';  
  signal LDB       : std_logic := '0';  
  signal alu_Z     : std_logic := '0';  
  signal alu_N     : std_logic := '0';  
  signal alu_FN    : std_logic_vector(1 downto 0) := (others => '0');  
  signal Y         : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');  
  signal C_intl    : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');  
  signal regA_out  : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');  
  signal regB_out  : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');  

BEGIN


inst_mux : entity work.mux                       
    generic map (N  => DATA_WIDTH)      -- Width of inputs and output.
    port map (
      data_in1  =>  Y,          -- Inputs.
      data_in2  =>  AB,
      s         =>  ABorALU,    -- Select signal.
      data_out  =>  C_intl      -- Output. 
    );         

inst_regA : entity work.reg                                
    generic map(N => DATA_WIDTH)        -- Width of inputs.
    port map  (
      clk       => clk,        -- Clock signal.
      en        => LDA,       -- Enable signal.
      data_in   => C_intl,      -- Input data.
      data_out  => regA_out      -- Output data.
    );

inst_regB : entity work.reg                                
    generic map(N => DATA_WIDTH)        -- Width of inputs.
    port map  (
      clk       => clk,        -- Clock signal.
      en        => LDB,       -- Enable signal.
      data_in   => C_intl,      -- Input data.
      data_out  => regB_out      -- Output data.
    );

inst_alu : entity work.alu 
    generic map(W => DATA_WIDTH)        -- Width of inputs.
    port map  (
      A         => regA_out,    -- Input operands.
      B         => regB_out,  
      fn        => alu_FN,      -- Function.
      C         => Y,           -- Result. This has the wrong name in the component!!
      Z         => alu_Z,       -- Result = 0 flag.
      N         => alu_N        -- Result neg flag.
   );                

inst_fsm : entity work.FSM 
    port map (
      clk       =>  clk,         -- The clock signal.
      reset     =>  reset,         -- RESET the module.
      ------------------------------------------------------------------------
      ABorALU   =>  ABorALU,
      LDA       =>  LDA,
      LDB       =>  LDB,
      alu_FN    =>  alu_FN,
      alu_Z     =>  alu_Z,
      alu_N     =>  alu_N
    );    


END behaviour;