----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad do liczenia œredniego odchylenia bezwzglêdnego z 64 próbek
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity odchylenie_tb is
    generic (M : integer := 32);
end odchylenie_tb;


architecture odchylenie_tb_arch of odchylenie_tb is


component liczenie_odchylenia
    generic (N: integer);
    Port ( RESET    : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           avg      : in unsigned (N-1 downto 0);
           gen      : in unsigned (N-1 downto 0);
           enable   : in STD_LOGIC;
           dev      : out unsigned (N-1 downto 0));
end component liczenie_odchylenia;


-- Wejœcia
   signal enable : std_logic := '0';
   signal CLK    : std_logic := '0';
   signal RESET  : std_logic := '0';
   signal gen    : unsigned (M-1 downto 0) := (others => '0');
   signal avg    : unsigned (M-1 downto 0) := to_unsigned(214, M);

-- Wyjœcia

   signal dev :  unsigned (M-1 downto 0);
   
-- Definicja sygna³u zegarowego
   constant CLK_period : time := 10 ns;


begin

   uut: liczenie_odchylenia 
       generic map (N => M)
       port map (
              RESET => RESET,
              CLK => CLK,
              enable => enable,
              gen => gen,
              avg => avg,
              dev => dev
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
      RESET <= '1';wait for 2*CLK_period;
      gen <= to_unsigned(10,M); wait for 2*CLK_period;
      enable <= '1'; wait for 2*CLK_period;
      
      for i in 1 to 120 loop
            gen  <= to_unsigned(i, M);
            wait for CLK_period;
      end loop;
      
	  assert false report "END" severity failure;
	  
   end process;


end odchylenie_tb_arch;
