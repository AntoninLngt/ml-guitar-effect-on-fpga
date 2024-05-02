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
        -- Signaux d'entr�e pour les transactions I2C
        i2c_busy : in STD_LOGIC;                       -- Indique si une transaction I2C est en cours
        i2c_data_rd : in STD_LOGIC_VECTOR(7 downto 0); -- Donn�es lues depuis le p�riph�rique I2C

        -- Signaux de sortie pour les transactions I2C
        i2c_ena : out STD_LOGIC;                       -- Active la transaction I2C
        i2c_addr : out STD_LOGIC_VECTOR(6 downto 0);   -- Adresse du p�riph�rique I2C
        i2c_rw : out STD_LOGIC;                        -- Lecture (1) ou �criture (0) lors de la transaction I2C
        i2c_data_wr : out STD_LOGIC_VECTOR(7 downto 0);-- Donn�es � �crire lors de la transaction I2C

        -- Autres signaux de contr�le
        clk : in STD_LOGIC;                           -- Horloge
        reset_n : in STD_LOGIC;                       -- Reset actif bas
        ack_error : in STD_LOGIC                       -- Indique une erreur d'acquittement
    );
end User_Logic;

architecture Behavioral of User_Logic is
    -- D�claration des signaux internes
    signal busy_prev : STD_LOGIC;
    signal busy_cnt : integer range 0 to 4 := 0;
    signal data_to_write : STD_LOGIC_VECTOR(7 downto 0); -- Exemple de donn�es � �crire
    signal new_data_to_write : STD_LOGIC_VECTOR(7 downto 0); -- Exemple de nouvelles donn�es � �crire
    signal data : STD_LOGIC_VECTOR(15 downto 0);         -- Exemple de donn�es re�ues

    -- D�claration de la machine � �tats avec l'�tat suppl�mentaire
    type all_states is (ready, start, command, slv_ack1, wr, rd, slv_ack2, mstr_ack, stop, get_data);
    signal state : all_states;

begin

    -- Logique de la machine � �tats
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= ready; -- Retour � l'�tat initial lors du reset
            busy_cnt <= 0;  -- R�initialisation du compteur de transactions
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
                            i2c_addr <= (others => '0'); -- Adresse du p�riph�rique
                            i2c_rw <= '0';               -- Lecture (1) ou �criture (0)
                            i2c_data_wr <= data_to_write; -- Donn�es � �crire
                        when 1 =>
                            i2c_rw <= '1';               -- Lecture (1)
                        when 2 =>
                            i2c_rw <= '0';               -- Ecriture (0)
                            i2c_data_wr <= new_data_to_write; -- Nouvelles donn�es � �crire
                            if i2c_busy = '0' then
                                data(15 downto 8) <= i2c_data_rd; -- Donn�es lues depuis le p�riph�rique
                            end if;
                        when 3 =>
                            i2c_rw <= '1';               -- Lecture (1)
                        when 4 =>
                            i2c_ena <= '0';              -- D�sactivation de la transaction
                            if i2c_busy = '0' then
                                data(7 downto 0) <= i2c_data_rd; -- Donn�es lues depuis le p�riph�rique
                                busy_cnt <= 0; -- R�initialisation du compteur de transactions
                                state <= ready; -- Transaction termin�e, retour � l'�tat ready
                            end if;
                        when others =>
                            null;
                    end case;

                when others =>
                    -- Autres �tats et logique
                    null;
            end case;
        end if;
    end process;

end Behavioral;