----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2024 12:45:54
-- Design Name: 
-- Module Name: sim I2C - Behavioral
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

entity I2C_Master_Controller_tb is
--  Port ( );
end I2C_Master_Controller_tb;

architecture tb_arch of I2C_Master_Controller_tb is
    -- Constant definitions
    constant CLK_PERIOD : time := 10 ns;  -- Clock period (100 MHz)
    
    -- Signals declaration for DUT (Design Under Test)
    signal clk_tb : std_logic := '0';  -- Testbench clock signal
    signal reset_tb : std_logic := '0';  -- Testbench reset signal
    -- Other signals used for stimulus
    signal ena_tb, rd_wr_tb : std_logic := '0';  -- Testbench enable and read/write signals
    signal slv_addr_tb : std_logic_vector(6 downto 0) := (others => '0');  -- Testbench slave address
    signal reg_addr_tb : std_logic_vector(7 downto 0) := (others => '0');  -- Testbench register address
    signal reg_data_tb : std_logic_vector(7 downto 0) := "10101010";  -- Testbench data to write
    
    -- Signals declaration for monitoring
    signal busy_tb : std_logic;
    signal SCL_tb, SDA_tb : std_logic;
    signal ack_error_tb : std_logic;
    signal data_rd_tb : std_logic_vector(7 downto 0);
    signal n_state_tb : integer range 0 to 8;
    signal bit_cnt_tb : integer range 0 to 7;
    signal addr_rw_tb : std_logic_vector(7 downto 0);
    signal  data_clk_tb  :  STD_LOGIC;

    -- Component instantiation
    component I2C_Master_Controller
        generic (
            input_clk : integer := 50_000_000;  -- Input clock frequency (50 MHz)
            bus_clk : integer := 400_000  -- I2C bus clock frequency (400 kHz)
        );
        Port (
            clk : in std_logic;
            reset : in std_logic;
            ena : in std_logic;
            rd_wr : in std_logic;
            slv_addr : in std_logic_vector(6 downto 0);
            reg_addr : in std_logic_vector(7 downto 0);
            reg_data : in std_logic_vector(7 downto 0);
            busy : out std_logic;
            SCL : inout std_logic;
            SDA : inout std_logic;
            ack_error : buffer std_logic;
            data_rd : out std_logic_vector(7 downto 0);
            n_state : out integer range 0 to 8;
            bit_cnt : inout integer range 0 to 7;
            addr_rw : inout std_logic_vector(7 downto 0);
            data_clk  :  inout STD_LOGIC
        );
    end component;

begin
    -- DUT instantiation
    DUT : I2C_Master_Controller
        generic map (
            input_clk => 50_000_000,  -- Input clock frequency (50 MHz)
            bus_clk => 400_000  -- I2C bus clock frequency (400 kHz)
        )
        port map (
            clk => clk_tb,
            reset => reset_tb,
            ena => ena_tb,
            rd_wr => rd_wr_tb,
            slv_addr => slv_addr_tb,
            reg_addr => reg_addr_tb,
            reg_data => reg_data_tb,
            busy => busy_tb,
            SCL => SCL_tb,
            SDA => SDA_tb,
            ack_error => ack_error_tb,
            data_rd => data_rd_tb,
            n_state => n_state_tb,
            bit_cnt => bit_cnt_tb,
            addr_rw => addr_rw_tb,
            data_clk => data_clk_tb
        );

    -- Clock process
    clk_process : process
    begin
        while now < 50000 ns loop  -- Run simulation for 1000 ns
            clk_tb <= not clk_tb;  -- Toggle the clock
            wait for CLK_PERIOD / 2;  -- Wait half of the clock period
        end loop;
        wait;  -- Wait indefinitely after simulation ends
    end process clk_process;

    -- Stimulus process
    stim_process : process
    begin
        -- Reset sequence
        reset_tb <= '0';
        wait for CLK_PERIOD;
        reset_tb <= '1';
        wait for CLK_PERIOD * 2;
        
        -- Enable I2C transaction
        
        slv_addr_tb <= "1010101";  -- Set slave address
        rd_wr_tb <= '0';
        reg_addr_tb <= "00000001";  -- Set register address
        reg_data_tb <= "11001100";  -- Set data to write
        ena_tb <= '1';
        wait for 10 ns;
        -- Wait for the transaction to complete
        
        wait until busy_tb = '0';
        rd_wr_tb <= '1';
        wait for 100 ns;
        
        wait until busy_tb = '0';
        ena_tb <= '0';
       
        -- Disable I2C transaction
        

        -- Fin de la simulation
        wait;
    end process;

end;