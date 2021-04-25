----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad do liczenia œredniej z 16 próbek - testbench
------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity srednia_tb is
    generic (M : integer := 16);
end srednia_tb;


architecture srednia_tb_arch of srednia_tb is


component liczenie_sredniej

        generic (N: integer);
        port(
            RESET : in STD_LOGIC;
            CLK : in STD_LOGIC;
            enable_in : in STD_LOGIC;
            gen : in unsigned (N-1 downto 0) ;
            avg : out unsigned (N-1 downto 0);
            enable_out : inout STD_LOGIC
            );
            
end component liczenie_sredniej;


-- Wejœcia
   signal enable_in : std_logic := '1';
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal gen : unsigned (M-1 downto 0) := (others => '0');
   

-- Wyjœcia

   signal avg :  unsigned (M-1 downto 0);
   signal enable_out :  STD_LOGIC;
   
   -- Definicja sygna³u zegarowego
   constant CLK_period : time := 10 ns;
   
      
begin

   uut: liczenie_sredniej 
   generic map (N => M)
   port map (
          RESET => RESET,
          CLK => CLK,
          enable_in => enable_in,
          gen => gen,
          avg => avg,
          enable_out => enable_out
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
   
      enable_in <= '1' ; 	
      RESET <= '0'; wait for 5.25*CLK_period;
      RESET <= '1';
      
      for i in 1 to 60 loop
            gen  <= to_unsigned(i, M);
            wait for CLK_period;
      end loop;
      
	  assert false report "END" severity failure;
	  
   end process;


end srednia_tb_arch;
