--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(7 downto 0); -- operands and opcode
        btnU    :   in std_logic; -- reset
        btnC    :   in std_logic; -- fsm cycle
        btnL    :   in std_logic; -- clk cycle
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;


architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	component controller_fsm is
	   port(
	       i_reset : in std_logic;
	       i_adv   : in std_logic;
	       o_cycle : out std_logic_vector(3 downto 0)
	   );
    end component;
    
    component ALU is
        port(
          i_A   : in std_logic_vector(7 downto 0);
          i_B   : in std_logic_vector(7 downto 0);
          i_op : in STD_LOGIC_VECTOR (2 downto 0);
          o_result : out STD_LOGIC_VECTOR (7 downto 0);
          o_flags : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

signal w_cycle     : std_logic_vector(3 downto 0);
signal w_result    : std_logic_vector(7 downto 0);


  
begin
	-- PORT MAPS ----------------------------------------
    controller : controller_fsm
        port map(
            i_reset => btnU,
            i_adv => btnC,
            o_cycle => w_cycle
        );
	
	--Synchronous Reset
	register_proc : process(clk)
    begin
      if rising_edge(clk) then
        if btnU = '1' then
            f_Q = "00";
        else
            f_Q <= f_Q_next;
        end if;
      end if;
    end process register_proc;
    
    
    --Asynchronous Reset
    register_proc : process(clk, btnL)
    begin   
        if btnL = '1' then
            f_Q <= "00";
        elsif(rising_edge(i_clk)) then
            f_Q <= f_Q_next;
        end if;
    end process register proc;
            
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end top_basys3_arch;
