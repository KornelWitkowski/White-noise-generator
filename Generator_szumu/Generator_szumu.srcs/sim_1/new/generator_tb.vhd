----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Komponent generuj¹cy szum bia³y - testbench
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity generator_tb is
    generic (M : integer := 24);
end generator_tb;


architecture generator_tb_arch of generator_tb is

 
    -- Deklaracja testowanego komponentu
 
    component generator
    
        generic (N: integer);
        port(
             RESET  : in  std_logic;
             CLK    : in  std_logic;
             SEED   : in  unsigned (3 downto 0);
             GEN    : out unsigned (M-1 downto 0)
            );
            
    end component;
     

   -- Wejœcia
   signal SEED : unsigned (3 downto 0):= "0111";
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';

 	-- Wyjœcia
   signal GEN : unsigned (M-1 downto 0);

   -- Definicja okresu zegarowego
   constant CLK_period : time := 10 ns;
 
begin
 
   uut: generator 
          generic map (N => M)
          port map (
          RESET => RESET,
          CLK => CLK,
          SEED => SEED,
          GEN => GEN
        );

   -- definicja procesu zegarowego
   zegar :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
 
   -- symulacja 
   stim_proc: process
   begin		
      RESET <= '0'; wait for 5.25*CLK_period;
      RESET <= '1'; wait for 100*CLK_period;
      RESET <= '0'; wait for 10*CLK_period;
	  RESET <= '1'; wait for 100*CLK_period;
	  assert false report "END" severity failure;
   end process;

end generator_tb_arch;
