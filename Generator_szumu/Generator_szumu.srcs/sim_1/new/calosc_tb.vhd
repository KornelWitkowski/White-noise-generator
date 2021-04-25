----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad generuj¹cy szum bia³y i wyliczaj¹cy jego œredni¹ wartoœæ i œrednie odchylenie bezwzglêdne - testbench
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity calosc_tb is
    generic (J : integer := 24);
end calosc_tb;

architecture calosc_tb_arch of calosc_tb is

component calosc
        generic (M : integer);
        port(
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        SEED : in unsigned (3 downto 0) ;
        GEN : out unsigned (M-1 downto 0) ;
        MEAN1 : out unsigned (M-1 downto 0);
        MEAN2 : out unsigned (M-1 downto 0);
        DEV: out unsigned (M-1 downto 0));
end component calosc;

-- Wejœcia
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal SEED : unsigned (3 downto 0) := (others => '0');
   
--Wyjœcia
    signal GEN : unsigned (J-1 downto 0);
    signal MEAN1 : unsigned (J-1 downto 0);
    signal MEAN2 : unsigned (J-1 downto 0);
    signal DEV : unsigned (J-1 downto 0);
    
--Definicja okresu zegarowego    
    constant CLK_period : time := 10 ns;

begin

   uut: calosc 
          generic map (M => J)
          port map (
          RESET => RESET,
          CLK => CLK,
          SEED => SEED,
          GEN => GEN,
          MEAN1 => MEAN1,
          MEAN2 => MEAN2,
          DEV => DEV
        );

   zegar :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;


   stim_proc: process
   begin		
      RESET <= '0'; wait for 5.25*CLK_period;
      RESET <= '1'; wait for 600*CLK_period;
      RESET <= '0'; wait for 10*CLK_period;
	  RESET <= '1'; wait for 100*CLK_period;
	  assert false report "END" severity failure;
   end process;


end calosc_tb_arch;
