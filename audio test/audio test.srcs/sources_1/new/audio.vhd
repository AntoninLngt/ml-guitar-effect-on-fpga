----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2024 12:34:56
-- Design Name: 
-- Module Name: audio - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AudioPassthrough is
    Port (
        -- Signal de contrôle
        ac_muten  : out std_logic;   -- Signal de sourdine
        -- Switch et leds
        sw         : in std_logic;  -- Interrupteurs pour contrôler la mise en sourdine de l'audio et autres fonctionnalités
        ledsw      : out std_logic
    );
end AudioPassthrough;

architecture Behavioral of AudioPassthrough is

begin
    process(sw)
    begin
        if sw = '1' then
            ledsw <= '1';
            ac_muten <= '1';
        else
            ledsw <= '0';
            ac_muten <= '0';
        end if;
    end process;
end Behavioral;