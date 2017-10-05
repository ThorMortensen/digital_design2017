-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Spars�, Rasmus Bo S�rensen and Mathias M�ller Bruhn
-- 		       :
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
    PORT (clk:   IN std_logic;				   -- The clock signal.
          resetIn: IN std_logic;				   -- Reset the module.
          req:   IN std_logic;				   -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);	-- The two operands.
          ack:   OUT std_logic;				   -- Computation is complete.
          C:     OUT unsigned(15 downto 0));	-- The result.
END gcd;

ARCHITECTURE FSMD OF gcd IS

TYPE state_type IS (reset, setup, load_a, ack_state, load_b, comp_sub_a_b, sub_b_a, result); -- Input your own state names

SIGNAL reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0);

SIGNAL state, next_state : state_type := reset;

signal fn : std_logic_vector(1 downto 0) := (others => '0');

signal y : unsigned(15 downto 0) := (others => '0');
signal c_intern : unsigned(15 downto 0) := (others => '0');


signal n :  std_logic := '0';
signal z :  std_logic := '0';

signal ab_or_alu : std_logic := '0';

signal lda : std_logic := '0';
signal ldb : std_logic := '0';

constant zeros : unsigned(y'range) := (others => '0');

BEGIN

-- Combinatoriel logic

CL: PROCESS (req,AB,state,reg_a,reg_b)
BEGIN
  next_state <= next_state;
  ack <= '0';
  fn <= "10";
  lda <= '0';
  ldb <= '0';
  ab_or_alu <= '1';

   CASE (state) IS
      when reset => 
        
        ab_or_alu <= '0';

        if req = '1' then 
          next_state <= setup;
        end if;
      
      when setup =>
      
        ab_or_alu <= '0';
        next_state <= load_a;
      
      when load_a =>

        reg_a <= AB;
        lda <= '1';
      
        if req = '0' and ab_or_alu = '1' then 
          next_state <= ack_state;
        elsif ab_or_alu = '0' then
          next_state <= comp_sub_a_b;
        end if;
      
      when ack_state => 
      
        ack <= '1';
      
        if req = '1' then 
          next_state <= load_b;
        end if;
      
      when load_b =>

        reg_b <= AB;
        fn <= "00";
        ldb <= '1';

        if req = '0' or ab_or_alu = '0' then 
          next_state <= comp_sub_a_b;
        end if;

      when comp_sub_a_b => 
        
        ack <= '1';
        ab_or_alu <= '0';
        
        if z = '1' then 
          next_state <= result;
        else
          if n = '0' then 
            next_state <= sub_b_a;
          else
            next_state <= load_b;
          end if;  
        end if;

      when sub_b_a => 

        fn <= "01";
        ab_or_alu <= '0';
        next_state <= load_a;

      when result => 

        fn <= "10";
        next_state <= reset;
        ab_or_alu <= '0';
     
   END CASE;
END PROCESS CL;

-- Registers

seq: PROCESS (clk, resetIn)
BEGIN
  if rising_edge(clk) then
    if resetIn = '1' then 
      state <= reset;
      reg_a <= (others => '0');
      reg_b <= (others => '0');
    else 
      state <= next_state;
      
      if lda = '1' then 
        reg_a <= c_intern;
      end if;

      if ldb = '1' then 
       reg_b <= c_intern;
      end if;

    end if;
  end if; 
END PROCESS seq;


alu: PROCESS (reg_a, reg_b, fn)
BEGIN
  case fn is 
    when "00" => y <= reg_a - reg_b;
    when "01" => y <= reg_b - reg_a;
    when "10" => y <= reg_a;
    when "11" => y <= reg_b;
  end case;
end process alu;

n <= y(15);
z <= '0' when y = zeros else '1';

with ab_or_alu select c_intern <=
   AB when '1', 
   y when '0';

C <= c_intern; 



END FSMD;
