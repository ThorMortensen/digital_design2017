-------------------------------------------------------------------------------
-- Author       : Thor Mortensen 2017
-- Module       : Relay (2.5A) and button IO board 
-- Related Doc. : 
-- Sourche File : apb_dbIO.vhd
-- HDL          : VHDL 1993
-- Hierarchy    :
-- Description  : Main module for reading button input (can be used as an output to relays as well)
-- 
-- Register interface:
--   Addr   Name   Bits   Dir Description
--
-- AMBA APB protocol specification taken from AMBA Specification (Rev 2.0)
-- (file name ARM IHI 0011A) chapter 5, especially sections 5.2 "APB
-- specification" and 5.5 "APB Slave".
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library grlib;
use     grlib.amba.all;
use     grlib.devices.all;

library rovsing;
use rovsing.constants_pkg.all;

entity apb_dbIO is
  generic (
    CLK_PERIOD_NS  : integer := 20; 
    DB_DELAY_MS    : integer := 20;
    pindex         : integer := 0;
    paddr          : integer := 16#000#;
    pmask          : integer := 16#fff#;
    pirq           : integer := 0);
  port (           
    clk_i          : in  std_logic;
    rst_i          : in  std_logic;
                   
    apb_i          : in  apb_slv_in_type;
    apb_o          : out apb_slv_out_type;
    
    contact_i      : in std_logic_vector(40 downto 1)
     
   -- relay_o       : out std_logic_vector(20 downto 1)--For future use
    ); 
end entity apb_dbIO;

architecture RTL of apb_dbIO is
    
  constant REVISION           : integer := 0;
  constant pconfig            : apb_config_type := (
     0 => ahb_device_reg(VENDOR_ROVSING, ROVSING_DBIO, 0, REVISION, pirq),
     1 => apb_iobar(paddr, pmask));
  
  constant SHIFT_DEPTH        : integer := 10;
  constant INPUT_COUNT        : integer := 40;
  constant CONTACTS_L         : integer := 0;
  constant CONTACTS_H         : integer := 1;
  
  subtype CONTACT_RANGE is natural range 19 downto 0;
  
  signal amba_addr   : natural range 0 to 3 := 0;
  
  --Contact common 
  type contact_db_shift_reg is array (1 to INPUT_COUNT) of std_logic_vector(SHIFT_DEPTH-1 downto 0);
  signal contact_shift  : contact_db_shift_reg := (others => (others => '0')); 
  signal contact_debounced  : std_logic_vector(40 downto 1) := (others => '0');
  signal contact_hold_l     : std_logic_vector(20 downto 1) := (others => '0');
  signal contact_hold_h     : std_logic_vector(40 downto 21):= (others => '0');
  signal contact_hold_rst_l : std_logic := '0';
  signal contact_hold_rst_h : std_logic := '0';
  signal contact_in : std_logic_vector(40 downto 1);

  --Timer stuff
  signal ms_en : std_logic  := '0';
  

begin
  
  ---------------------------------------------
  --              AMBA  
  ---------------------------------------------
    --APB I/O
  -- Drive outputs
  apb_o.pconfig <= pconfig;
  apb_o.pirq    <= (others => '0');
  apb_o.pindex  <= pindex;
  
  amba_addr <= to_integer(unsigned(apb_i.paddr(6 downto 2)));
  contact_in <= not contact_i;
    
  amba_get_reg : process (clk_i)
    variable rdata : std_logic_vector(31 downto 0) := (others => '0');
  begin
    if rising_edge(clk_i) then
      
      contact_hold_rst_l <= '0'; 
      contact_hold_rst_h <= '0'; 
      rdata := (others => '0');
      
      --Read
      case amba_addr is
        when CONTACTS_L   => rdata(CONTACT_RANGE) := contact_hold_l; 
        when CONTACTS_H   => rdata(CONTACT_RANGE) := contact_hold_h; 
        when others          => null;
      end case;
      apb_o.prdata <= rdata;
     
     
      --Write
      if apb_i.psel(pindex) = '1' and apb_i.pwrite = '1' and apb_i.penable = '1' and apb_i.paddr(6) = '0' then
        case amba_addr is
          when CONTACTS_L => contact_hold_rst_l <= '1';
          when CONTACTS_H => contact_hold_rst_h <= '1';
          when others => null;
        end case;
        
      end if;
   
   end if;
  end process amba_get_reg;
  
  ---------------------------------------------
  --          Timer 
  ---------------------------------------------  
  counter_en: entity rovsing.Clock_enable
  generic map (
    CLK_PERIOD_NS => CLK_PERIOD_NS
  )
  port map (
    clk           => clk_i,
    clk_en_usec   => open,
    clk_en_100us  => open,
    clk_en_msec   => ms_en
  );
  
  ---------------------------------------------
  --          Debounce 
  --------------------------------------------- 
  
  db_shift_reg : process (clk_i)
  begin 
    if rising_edge(clk_i) then
      
      for i in 1 to INPUT_COUNT loop
      
        if ms_en = '1' then 
          contact_shift(i) <= contact_shift(i)(SHIFT_DEPTH-2 downto 0) & contact_in(i);
        end if;
        
      end loop;
    end if;
  end process db_shift_reg;
  
 -- out_db: for i in 1 to INPUT_COUNT generate
 --   contact_debounced(i) <= r_allOnes(contact_shift(i));
 --end generate;   
 
 hold_contacts : process (clk_i)
 begin
    if rising_edge(clk_i) then
       if (contact_hold_rst_l = '1') then 
          contact_hold_l <= (others => '0');
       else
          contact_hold_l <= contact_hold_l or contact_debounced(20 downto 1);
       end if;
       
       if (contact_hold_rst_h = '1') then 
          contact_hold_h <= (others => '0');
       else
          contact_hold_h <= contact_hold_h or contact_debounced(40 downto 21);
       end if;
    end if;
 end process hold_contacts;
 

end architecture RTL;


























































