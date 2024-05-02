----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 12:14:05
-- Design Name: 
-- Module Name: User_logic - Behavioral
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

entity User_Logic is
    Port (
        -- Signaux d'entrée pour les transactions I2C
        i2c_busy : in STD_LOGIC;                       -- Indique si une transaction I2C est en cours
        i2c_data_rd : in STD_LOGIC_VECTOR(7 downto 0); -- Données lues depuis le périphérique I2C

        -- Signaux de sortie pour les transactions I2C
        i2c_ena : out STD_LOGIC;                       -- Active la transaction I2C
        i2c_addr : out STD_LOGIC_VECTOR(6 downto 0);   -- Adresse du périphérique I2C
        i2c_rw : out STD_LOGIC;                        -- Lecture (1) ou écriture (0) lors de la transaction I2C
        i2c_data_wr : out STD_LOGIC_VECTOR(7 downto 0);-- Données à écrire lors de la transaction I2C

        -- Autres signaux de contrôle
        clk : in STD_LOGIC;                           -- Horloge
        reset_n : in STD_LOGIC;                       -- Reset actif bas
        ack_error : in STD_LOGIC                       -- Indique une erreur d'acquittement
    );
end User_Logic;

architecture Behavioral of User_Logic is
    -- Déclaration des signaux internes
    signal busy_prev : STD_LOGIC;
    signal busy_cnt : integer range 0 to 4 := 0;
    signal data_to_write : STD_LOGIC_VECTOR(7 downto 0); -- Exemple de données à écrire
    signal new_data_to_write : STD_LOGIC_VECTOR(7 downto 0); -- Exemple de nouvelles données à écrire
    signal data : STD_LOGIC_VECTOR(15 downto 0);         -- Exemple de données reçues

    -- Déclaration de la machine à états avec l'état supplémentaire
    type all_states is (ready, start, command, slv_ack1, wr, rd, slv_ack2, mstr_ack, stop, get_data);
    signal state : all_states;

begin

    -- Logique de la machine à états
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= ready; -- Retour à l'état initial lors du reset
            busy_cnt <= 0;  -- Réinitialisation du compteur de transactions
        elsif rising_edge(clk) then
            case state is
                when get_data =>
                    busy_prev <= i2c_busy;
                    if busy_prev = '0' and i2c_busy = '1' then
                        busy_cnt <= busy_cnt + 1;
                    end if;
                    case busy_cnt is
                        when 0 =>
                            i2c_ena <= '1';
                            i2c_addr <= (others => '0'); -- Adresse du périphérique
                            i2c_rw <= '0';               -- Lecture (1) ou écriture (0)
                            i2c_data_wr <= data_to_write; -- Données à écrire
                        when 1 =>
                            i2c_rw <= '1';               -- Lecture (1)
                        when 2 =>
                            i2c_rw <= '0';               -- Ecriture (0)
                            i2c_data_wr <= new_data_to_write; -- Nouvelles données à écrire
                            if i2c_busy = '0' then
                                data(15 downto 8) <= i2c_data_rd; -- Données lues depuis le périphérique
                            end if;
                        when 3 =>
                            i2c_rw <= '1';               -- Lecture (1)
                        when 4 =>
                            i2c_ena <= '0';              -- Désactivation de la transaction
                            if i2c_busy = '0' then
                                data(7 downto 0) <= i2c_data_rd; -- Données lues depuis le périphérique
                                busy_cnt <= 0; -- Réinitialisation du compteur de transactions
                                state <= ready; -- Transaction terminée, retour à l'état ready
                            end if;
                        when others =>
                            null;
                    end case;

                when others =>
                    -- Autres états et logique
                    null;
            end case;
        end if;
    end process;

end Behavioral;