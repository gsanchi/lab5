----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

    component ripple_adder is
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component;


--    component complete_ALU is
--        port (
--            i_A     : in std_logic;
--            i_B     : in std_logic;
--            i_op    : in std_logic;
--            o_result : in std_logic;
--            o_flags : in std_logic 
--        );
--    end component;
            
    signal w_carry  : STD_LOGIC_VECTOR(1 downto 0);
    signal w_B  : STD_LOGIC_VECTOR(7 downto 0);
    signal w_sum  : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_and  : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_or  : STD_LOGIC_VECTOR(7 downto 0);
--    signal w_flags : std_logic_vector(3 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    
begin
    
    w_B <= not i_B when i_op ="000" else i_B;
    
    complete_ALU_0: ripple_adder
    port map(
        A => i_A(3 downto 0),
        B => w_B(3 downto 0),
        Cin => i_op(0),
        S => w_sum(3 downto 0),
        Cout => w_carry(0)
    );

    complete_ALU_1: ripple_adder
    port map(
        A => i_A(7 downto 4),
        B => w_B(7 downto 4),
        Cin => w_carry(0),
        S => w_sum(7 downto 4),
        Cout => w_carry(1)
    );
    
    
    
    
    w_result <= w_sum(7 downto 0) when i_op = "000" else
                w_sum(7 downto 0) when i_op = "001" else
                (i_A and i_B) when i_op = "010" else
                (i_A or i_B) when i_op = "011" else
                w_sum;
                
    o_flags(3) <= w_sum(7);
    o_flags(2) <= '1' when (w_result = "00000000") else '0';
    o_flags(1) <= w_carry(1) and not(i_op(1));
    o_flags(0) <= not(i_A(7) xor i_B(7) xor i_op(0)) and (i_A(7) xor w_result(7)) and (not i_op(1));
    o_result <= w_result;

end Behavioral;
