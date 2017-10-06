-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
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

ENTITY gcd IS
    PORT (clk:   IN std_logic;           -- The clock signal.
          reset: IN std_logic;           -- RESET the module.
          req:   IN std_logic;           -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);  -- The two operands.
          ack:   OUT std_logic;          -- Computation is complete.
          C:     OUT unsigned(15 downto 0));  -- The result.
END gcd;

ARCHITECTURE FSMD OF gcd IS

TYPE state_type IS (IDLE, LOAD_A, LOAD_B, CALC); -- Input your own state names

SIGNAL reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0) := (others => '0');
SIGNAL state, next_state : state_type := IDLE;

signal res : unsigned(15 downto 0) := (others => '0');
alias a_lessthan_b : std_logic is res(15); 


BEGIN

-- Outputs
C <= reg_a; 

-- Sequential logic

res <= (reg_a - reg_b); 


-- Combinatorial logic
CL: PROCESS (req,AB,state,reg_a,reg_b, res)
BEGIN
  next_state <= next_state;
  ack <= '0';
  next_reg_a <= reg_a;
  next_reg_b <= reg_b;

   CASE (state) IS
      when IDLE => 

        if req = '1' then 
          next_state <= LOAD_A;
          ack <= '1';
          next_reg_a <= AB;
        end if;

      when LOAD_A =>

        if req = '1' then
          next_state <= LOAD_B;
        end if;

      when LOAD_B =>

        next_reg_b <= AB;
        next_state <= CALC;

      when CALC => 
        
        if res = 0  then -- Check equality (a - b == 0)
          ack <= '1';
          next_state <= IDLE;

        elsif a_lessthan_b = '1' then  -- Check a < b --> a - b == a < 0
            next_reg_b <=  not res + 1; -- Invert sign to get b - a
        else
            next_reg_a <= res;
        end if;

      when others => 
        null;

   END CASE;
END PROCESS CL;


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



END FSMD;
