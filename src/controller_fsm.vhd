----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is 
    type sm_state is (s0_clear, s1_load1, s2_load2, s3_display);
    
    signal current_state, next_state: sm_state;

begin
        -- Next State Logic            
        next_state <=  current_state                when i_adv = '0' else
                       s1_load1 when (current_state = s0_clear) else 
                       s2_load2 when (current_state = s1_load1 ) else 
                       s3_display when (current_state = s2_load2) else
                       s0_clear when (current_state = s3_display) else
                       s0_clear; --reset state
               
        -- Output logic 
        with current_state select
        o_cycle <= "0001" when s0_clear,
                   "0010" when s1_load1,
                   "0100" when s2_load2,
                   "1000" when s3_display,
                   "0001" when others;
                   
                   
       state_register : process(i_adv, i_reset)
       begin
           if rising_edge(i_adv) then
              if i_reset = '1' then
                  current_state <= s0_clear;
              else
                   current_state <= next_state;
              end if;
          end if;
       end process state_register;
         


end FSM;
