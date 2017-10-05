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

TYPE state_type IS (RESET_STATE, LOAD_A, LOAD_B, ACK_STATE,  SUB_A_B, SUB_B_A, SAVE_A, SAVE_B, RESULT); -- Input your own state names

SIGNAL reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0) := (others => '0');

SIGNAL state, next_state : state_type := RESET_STATE;

--constant zeros : unsigned(y'range) := (others => '0');
signal res : unsigned(15 downto 0) := (others => '0');

constant SELECT_A_SUB_B : std_logic := '0';
constant SELECT_B_SUB_A : std_logic := '1';

alias A_LESSTHAN_B : std_logic is res(15); 

signal calc_select : std_logic := SELECT_A_SUB_B;

BEGIN

-- Combinatoriel logic

CL: PROCESS (req,AB,state,reg_a,reg_b, clk)
BEGIN
  next_state <= next_state;
  calc_select <= SELECT_A_SUB_B;
  ack <= '0';
  next_reg_a <= reg_a;
  next_reg_b <= reg_b;

   CASE (state) IS
      when RESET_STATE => 
        
        if req = '1' then 
          next_state <= LOAD_A;
          ack <= '1';
          next_reg_a <= AB;
        end if;
      
      when LOAD_A =>


        if req = '1' then
          next_state <= LOAD_B;
        end if;
      
      --when ACK_STATE => 
      --  ack <= '0';
      --  if req = '1' then 
      --    next_state <= LOAD_B;
      --  end if;
      
      when LOAD_B =>

        next_reg_b <= AB;
        next_state <= SUB_A_B;

      when SUB_A_B => 
        

        if res = 0  then 
          ack <= '1';
          next_state <= RESET_STATE;
        else
          if res(15) = '1' then 
            next_state <= SAVE_B;
            calc_select <= SELECT_B_SUB_A;
          else
            next_reg_a <= res;
          end if;  
        end if;

      when SAVE_B => 

      next_state <= SUB_A_B;
      next_reg_b <= res;

      when others => 
        null;

   END CASE;
END PROCESS CL;


res <= (reg_a - reg_b) when calc_select = SELECT_A_SUB_B else 
       (reg_b - reg_a) when calc_select = SELECT_B_SUB_A;

C <= reg_a;
-- Registers

seq: PROCESS (clk, reset)
BEGIN
  if rising_edge(clk) then
    if reset = '1' then 
      state <= RESET_STATE;
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
