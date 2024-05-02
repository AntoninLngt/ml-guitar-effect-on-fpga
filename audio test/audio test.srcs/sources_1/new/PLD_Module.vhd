----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 12:25:10
-- Design Name: 
-- Module Name: PLD_Module - Behavioral
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

entity PLD_Module is
    Port (
        -- Ports pour la communication I2C
        -- (ajuster les types de signaux en fonction des spécifications I2C)
        clk : in STD_LOGIC;                          
        reset_n : in STD_LOGIC; 
        i2c_scl : in STD_LOGIC;
        i2c_sda : inout STD_LOGIC
    );
end PLD_Module;

architecture Behavioral of PLD_Module is
    -- Déclarations des signaux internes
    signal ena : STD_LOGIC;
    signal addr : STD_LOGIC_VECTOR(6 downto 0);
    signal rw : STD_LOGIC;
    signal data_wr  : STD_LOGIC_VECTOR(7 downto 0);
    signal i2c_data_rd : STD_LOGIC_VECTOR(7 downto 0);
    signal ack_error : STD_LOGIC;
    signal i2c_busy : STD_LOGIC;
    
    

begin
    -- Instanciation de la logique utilisateur
    User_Logic: entity work.User_Logic
        port map (
            -- Connecter les ports de la logique utilisateur
            clk => clk,
            reset_n => reset_n,
            i2c_busy => i2c_busy,
            i2c_data_rd => i2c_data_rd,
            ack_error => ack_error
            -- Ajouter d'autres ports si nécessaire
        );

    -- Instanciation de l'esclave audio codec
    Codec_I2C: entity work.Codec_I2C
        port map (
            -- Connecter les ports de l'esclave audio codec
            clk => clk,
            reset_n => reset_n,
            ena  => ena ,
            rw => rw,
            data_wr  => data_wr ,
            addr => addr,
            sda => i2c_sda,
            scl => i2c_scl
 
            -- Ajouter d'autres ports si nécessaire
        );

    -- Ajouter de la logique de contrôle ici
    -- (par exemple, envoyer des commandes à l'I2C pour configurer l'esclave audio codec,
    -- échanger des données entre la logique utilisateur et l'esclave audio codec, etc.)

    -- Instanciation du module I2C

end Behavioral;