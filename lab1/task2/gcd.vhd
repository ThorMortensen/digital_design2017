-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Spars�, Rasmus Bo S�rensen and Mathias M�ller Bruhn
--           :
--  Purpose    :  This is a FSMD (finite state machine with datapath) 
--             :  implementation the GCD circuit
--             :
--  Revision   :  02203 fall 2017 v.4
--
-- -----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use ieee.std_logic_misc.all;

ENTITY gcd IS
    PORT (clk:   IN std_logic;           -- The clock signal.
          reset: IN std_logic;           -- RESET the module.
          req:   IN std_logic;           -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);  -- The two operands.
          ack:   OUT std_logic;          -- Computation is complete.
          C:     OUT unsigned(15 downto 0));  -- The result.
END gcd;

ARCHITECTURE FSMD OF gcd IS

TYPE state_type IS (IDLE, LOAD_A, LOAD_B, CALC, RESULT, SWAP); -- Input your own state names

signal reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0) := (others => '0'); 
signal state, next_state : state_type := IDLE;

signal res : unsigned(15 downto 0) := (others => '0');
alias a_lessthan_b : std_logic is res(15); 

signal swap_a_b : std_logic := '1';
signal src0     : unsigned(15 downto 0);
signal src1     : unsigned(15 downto 0);

BEGIN



----------------------------------------------------------------------
----------------------------------------------------------------------
--                  Improved Design 
----------------------------------------------------------------------
----------------------------------------------------------------------

-- Combinatorial logic
src0 <= reg_a when swap_a_b = '0' else reg_b;
src1 <= reg_b when swap_a_b = '0' else reg_a; --(others =>       swap_a_b);
res <= (src0 - src1);

CL_improved: PROCESS (req,AB,state,reg_a,reg_b, res)
BEGIN
  next_state <= state;
  ack <= '0';
  next_reg_a <= reg_a;
  next_reg_b <= reg_b;
  swap_a_b <= '0';

   CASE (state) IS
      when IDLE => 

        if req = '1' then 
          next_state <= LOAD_A;
          next_reg_a <= AB;
          ack <= '1';
        end if;

      when LOAD_A =>

        ack <= '1';
        if req = '0' then
          next_state <= LOAD_B;
        end if;
      
      when LOAD_B =>

        if req = '1' then
          next_reg_b <= AB;
          next_state <= CALC;
        end if;

      when CALC => 
        
        if or_reduce(std_logic_vector(res)) = '0' then -- Check equality (a - b == 0)
            next_state <= RESULT;
        elsif a_lessthan_b = '1' then  -- Check a < b --> a - b == a < 0
          next_state <= SWAP;
        else
            next_reg_a <= res;
        end if;

      when SWAP =>
        swap_a_b <= '1';
        next_reg_b <= res;
        next_state <= CALC;

      when RESULT =>
        ack <= '1';
        if req = '0' then
          next_state <= IDLE;
        end if;

      when others => 
        null;

   END CASE;
END PROCESS CL_improved;



-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics   @@@@@@@@  WITH EQUAL  @@@@@@@@
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
--     2 Input      1 Bit        Muxes := 2     
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics  @@@@@@@@  WITH OR_REDUCE  @@@@@@@@
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
--     2 Input      1 Bit        Muxes := 1   <--- One less mux here 
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
--                  Original Design 
----------------------------------------------------------------------
----------------------------------------------------------------------

---- Combinatorial logic
-- res <= (reg_a - reg_b); 

--CL_original: PROCESS (req,AB,state,reg_a,reg_b, res)
--BEGIN
--  next_state <= state;
--  ack <= '0';
--  next_reg_a <= reg_a;
--  next_reg_b <= reg_b;

--   CASE (state) IS
--      when IDLE => 

--        if req = '1' then 
--          next_state <= LOAD_A;
--          next_reg_a <= AB;
--          ack <= '1';

--        end if;

--      when LOAD_A =>

--        ack <= '1';
--        if req = '0' then
--          next_state <= LOAD_B;
--        end if;
      
--      when LOAD_B =>

--        if req = '1' then
--          next_reg_b <= AB;
--          next_state <= CALC;
--        end if;

--      when CALC => 
        
--        if res = 0  then -- Check equality (a - b == 0)
--            next_state <= RESULT;
--        elsif a_lessthan_b = '1' then  -- Check a < b --> a - b == a < 0
--            next_reg_b <=  not res + 1; -- Invert sign to get b - a
--        else
--            next_reg_a <= res;
--        end if;

--      when RESULT =>
--        ack <= '1';
--        if req = '0' then
--          next_state <= IDLE;
--        end if;

--      when others => 
--        null;

--   END CASE;
--END PROCESS CL_original;


-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics  @@@@@@@@  ORIGINAL  @@@@@@@@
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
--     2 Input     16 Bit       Adders := 1     
--+---Registers : 
--                 16 Bit    Registers := 2     
--+---Muxes : 
--     6 Input     16 Bit        Muxes := 2     
--     6 Input      3 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 3     
--     6 Input      1 Bit        Muxes := 4     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--Start RTL Hierarchical Component Statistics  @@@@@@@@  OPTIMIZED  @@@@@@@@
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
--+---Adders :                                <-- One less adder              
--     3 Input     16 Bit       Adders := 1      
--+---Registers : 
--                 16 Bit    Registers := 2     
--+---Muxes :                                 <-- More muxes 
--     2 Input     16 Bit        Muxes := 2     
--     7 Input     16 Bit        Muxes := 2     
--     9 Input      3 Bit        Muxes := 1     
--     2 Input      1 Bit        Muxes := 1  
--     7 Input      1 Bit        Muxes := 5     
-----------------------------------------------------------------------------------
--Finished RTL Hierarchical Component Statistics
-----------------------------------------------------------------------------------








-- Registers

seq: PROCESS (clk, reset)
BEGIN
  if rising_edge(clk) then
    if reset = '1' then 
      state <= IDLE;
      reg_a <= (others => '0');
      reg_b <= (others => '0');
    else 
      state <= next_state;
      reg_a <= next_reg_a;
      reg_b <= next_reg_b;
    end if;
  end if; 
END PROCESS seq;

-- Outputs
C <= reg_a; 

END FSMD;
