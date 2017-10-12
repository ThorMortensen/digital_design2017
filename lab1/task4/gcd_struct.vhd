
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
          alu_Z     : in std_logic;  
          alu_N     : in std_logic;
          alu_FN    : out std_logic_vector(1 downto 0));  
END FSM;


ARCHITECTURE behaviour OF FSM IS

TYPE state_type IS (IDLE, LOAD_A, LOAD_B, CALC, SWAP, RESULT); 

signal state    : state_type := IDLE;
signal next_state    : state_type := IDLE;

constant SUB_A_B  : std_logic_vector := "00"; 
constant SUB_B_A  : std_logic_vector := "01"; 
constant PASS_A   : std_logic_vector := "10"; 
constant PASS_B   : std_logic_vector := "11"; 

BEGIN

CL : process(state, req ,alu_Z, alu_N) 
begin
  next_state  <= state;
  ack         <= '0';
  ABorALU     <= '0';
  LDA         <= '0';
  LDB         <= '0';
  alu_FN      <= PASS_A;

   case (state) IS
      when IDLE => 

        if req = '1' then 
          next_state <= LOAD_A;
          LDA <= '1';
          ack <= '1';
          ABorALU <= '1';
        end if;

      when LOAD_A =>

        ABorALU <= '1';
        if req = '0' then
          next_state <= LOAD_B;
        end if;

      when LOAD_B =>

        LDB <= '1';
        ABorALU <=  '1' ;

        if req = '1' then
          next_state <= CALC;
        end if;

      when CALC => 

        alu_FN  <= SUB_A_B;
        if alu_Z = '1'  then 
          next_state <= RESULT;
        elsif alu_N = '1' then 
          next_state <= SWAP;
        else
          LDA <= '1';
        end if;

      when SWAP =>

        LDB <= '1';
        alu_FN <= SUB_B_A;
        next_state <= CALC;

      when RESULT =>
        ack     <= '1';
        if req = '0' then
          next_state <= IDLE;
        end if;
      when others => 
        null;
   end case;
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


inst_buf : entity work.tri                                
    generic map (N  => DATA_WIDTH)      -- Width of inputs.
    port map ( 
      data_in  => C_intl, -- Input.
      data_out => C       -- Output.
      );       

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
      clk       => clk,         -- The clock signal.
      reset     => reset,         -- RESET the module.
     ----------------------------------------------------------------------
      req       => req,
      ack       => ack,
     ------------------------------------------------------------------------
      ABorALU   => ABorALU,
      LDA       => LDA,
      LDB       => LDB,
      alu_FN    => alu_FN,
      alu_Z     => alu_Z,
      alu_N     => alu_N
    );    


-----------------------------------------------------------------------------------
--Start RTL Component Statistics 
-----------------------------------------------------------------------------------
--Detailed RTL Component Info : 
--+---Adders : 
--     2 Input     17 Bit       Adders := 1     
--     3 Input     16 Bit       Adders := 1     
--+---Registers : 
--                 16 Bit    Registers := 2     
--                 10 Bit    Registers := 1     
--                  1 Bit    Registers := 1     
--+---Muxes : 
--     2 Input     16 Bit        Muxes := 1     
--     4 Input     16 Bit        Muxes := 3     
--     9 Input      3 Bit        Muxes := 1     
--     7 Input      2 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 2     
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Component Statistics 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics 
-----------------------------------------------------------------------------------
--Hierarchical RTL Component report 
--Module debounce 
--Detailed RTL Component Info : 
--+---Adders : 
--     2 Input     17 Bit       Adders := 1     
--+---Registers : 
--                 10 Bit    Registers := 1     
--                  1 Bit    Registers := 1     
--Module mux 
--Detailed RTL Component Info : 
--+---Muxes : 
--     2 Input     16 Bit        Muxes := 1     
--Module reg 
--Detailed RTL Component Info : 
--+---Registers : 
--                 16 Bit    Registers := 1     
--Module alu 
--Detailed RTL Component Info : 
--+---Adders : 
--     3 Input     16 Bit       Adders := 1     
--+---Muxes : 
--     4 Input     16 Bit        Muxes := 3     
--     2 Input      1 Bit        Muxes := 1     
--Module FSM 
--Detailed RTL Component Info : 
--+---Muxes : 
--     9 Input      3 Bit        Muxes := 1     
--     7 Input      2 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 1     
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
--Start RTL Component Statistics 
-----------------------------------------------------------------------------------
--Detailed RTL Component Info : 
--+---Adders : 
--     2 Input     17 Bit       Adders := 1     
--     3 Input     16 Bit       Adders := 1     
--+---Registers : 
--                 16 Bit    Registers := 2     
--                 10 Bit    Registers := 1     
--                  1 Bit    Registers := 1     
--+---Muxes : 
--     2 Input     16 Bit        Muxes := 2     
--     7 Input     16 Bit        Muxes := 2     
--     9 Input      3 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 1     
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Component Statistics 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics 
-----------------------------------------------------------------------------------
--Hierarchical RTL Component report 
--Module debounce 
--Detailed RTL Component Info : 
--+---Adders : 
--     2 Input     17 Bit       Adders := 1     
--+---Registers : 
--                 10 Bit    Registers := 1     
--                  1 Bit    Registers := 1     
--Module gcd 
--Detailed RTL Component Info : 
--+---Adders : 
--     3 Input     16 Bit       Adders := 1     
--+---Registers : 
--                 16 Bit    Registers := 2     
--+---Muxes : 
--     2 Input     16 Bit        Muxes := 2     
--     7 Input     16 Bit        Muxes := 2     
--     9 Input      3 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 1     
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------




END behaviour;