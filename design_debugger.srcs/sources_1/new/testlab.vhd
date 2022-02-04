----------------------------------------------------------------------------------
-- Mitchell Clark
-- CSCE 836
-- 5/13/21
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

entity testlab is
           Port ( 
           sysclk     : in    std_logic; -- system clock
           sw         : in    std_logic_vector(7 downto 0);
           led        : out   std_logic_vector(7 downto 0);           
           
           -- Ethernet Control signals
           eth_int_b : in    std_logic; -- interrupt
           eth_pme_b : in    std_logic; -- power management event
           eth_rst_b : out   std_logic := '0'; -- reset
           -- Ethernet Management interface
           eth_mdc   : out   std_logic := '0'; 
           eth_mdio  : inout std_logic := '0';
           -- Ethernet Receive interface
           eth_rxck  : in    std_logic; 
           eth_rxctl : in    std_logic;
           eth_rxd   : in    std_logic_vector(3 downto 0);
           -- Ethernet Transmit interface
           eth_txck  : out   std_logic := '0';
           eth_txctl : out   std_logic := '0';
           eth_txd   : out   std_logic_vector(3 downto 0) := (others => '0')
           );
end testlab;

architecture Behavioral of testlab is

component gigabit_test is
    generic(N: integer range 1 to 1024 := 128);
    Port ( sysclk     : in    std_logic; -- system clock
           sw         : in    std_logic_vector(7 downto 0);
           led        : out   std_logic_vector(7 downto 0);
           payload    : in    std_logic_vector(N-1 downto 0); --generic for data transmitted
           pkt_sent_n : out   std_logic; -- when low, signals last packet was sent           
           
           -- Ethernet Control signals
           eth_int_b : in    std_logic; -- interrupt
           eth_pme_b : in    std_logic; -- power management event
           eth_rst_b : out   std_logic := '0'; -- reset
           -- Ethernet Management interface
           eth_mdc   : out   std_logic := '0'; 
           eth_mdio  : inout std_logic := '0';
           -- Ethernet Receive interface
           eth_rxck  : in    std_logic; 
           eth_rxctl : in    std_logic;
           eth_rxd   : in    std_logic_vector(3 downto 0);
           -- Ethernet Transmit interface
           eth_txck  : out   std_logic := '0';
           eth_txctl : out   std_logic := '0';
           eth_txd   : out   std_logic_vector(3 downto 0) := (others => '0')
    );
end component;

signal fakedata1 : std_logic_vector(127 downto 0) := x"de7e57ab1edeadbeef1abe11eded1b1e";
signal fakedata2 : std_logic_vector(127 downto 0) := x"C1A551F1ED2C1CADA5B0de1114a111e5";
signal busy : std_logic := '1';

begin

ethernet: gigabit_test
    generic map(N => 128)
    port map(
    sysclk => sysclk,
    sw => sw,
    led => led,
    payload => fakedata1,
    pkt_sent_n => busy,
    eth_int_b => eth_int_b,
    eth_pme_b => eth_pme_b,
    eth_rst_b => eth_rst_b,
    eth_mdc => eth_mdc,
    eth_mdio => eth_mdio,
    eth_rxck => eth_rxck,
    eth_rxctl => eth_rxctl,
    eth_rxd => eth_rxd,
    eth_txck => eth_txck,
    eth_txctl => eth_txctl,
    eth_txd => eth_txd
    );


end Behavioral;
