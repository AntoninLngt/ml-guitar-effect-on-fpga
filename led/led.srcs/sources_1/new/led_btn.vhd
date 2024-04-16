----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2024 13:57:24
-- Design Name: 
-- Module Name: led_btn - Behavioral
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

entity led_btn is
    Port ( led : out STD_LOGIC;
           btn : in STD_LOGIC);
end led_btn;

architecture Behavioral of led_btn is

begin

    process(btn)
    begin
        if btn = '1' then
            -- Si le bouton est enfonc�, allumer la LED
            led <= '1';
        else
            -- Si le bouton est rel�ch�, �teindre la LED
            led <= '0';
        end if;
    end process;


end Behavioral;
