----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad generuj¹cy szum bia³y i wyliczaj¹cy jego œredni¹ wartoœæ i œrednie odchylenie bezwzglêdne.
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity calosc is
    generic (M : integer := 32);
    Port ( CLK      : in STD_LOGIC;
           RESET    : in STD_LOGIC;
           SEED     : IN  unsigned (3 downto 0);
           MEAN1    : out unsigned (M-1 downto 0);
           MEAN2    : out unsigned (M-1 downto 0);
           DEV      : out unsigned (M-1 downto 0);
           GEN      : out unsigned (M-1 downto 0));
end calosc;

architecture calosc_arch of calosc is

component generator
   generic (N : integer := M);
    port(
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         SEED : IN  unsigned (3 downto 0);
         GEN : OUT unsigned (N-1 downto 0)
        );
end component;

component liczenie_sredniej
    generic (N : integer := M);
    Port ( RESET        : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           enable_in    : in STD_LOGIC;                     -- sygna³ w³¹czaj¹cy zliczanie
           gen          : in unsigned (N - 1 downto 0) ;    -- wejœcie sygna³u generatora
           avg          : out unsigned (N - 1 downto 0);    -- wyliczona œrednia     
           enable_out   : out STD_LOGIC);                   -- sygna³ informuj¹cy dalsze uk³adu o zakoñczeniu liczenia
end component liczenie_sredniej;

component liczenie_odchylenia 
    generic (N : integer := M);
    Port ( RESET    : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           avg      : in unsigned (N-1 downto 0);
           gen      : in unsigned (N-1 downto 0);
           enable   : in STD_LOGIC;
           dev      : out unsigned (N-1 downto 0));
end component liczenie_odchylenia;

signal gen0 : unsigned (M-1 downto 0);
signal mean1_wew : unsigned (M-1 downto 0);
signal mean2_wew : unsigned (M-1 downto 0);
signal dev_wew : unsigned (M-1 downto 0);
signal enable : std_logic;
signal enable1 : std_logic;

begin

generatorek: 	  generator port map (CLK => CLK, RESET => RESET, SEED => SEED, GEN => gen0);
srednia1: 	      liczenie_sredniej port map (CLK => CLK, RESET => RESET, enable_in => '1', gen => gen0, avg =>mean1_wew, enable_out => enable);
srednia2: 	      liczenie_sredniej port map (CLK => CLK, RESET => RESET, enable_in => enable, gen => mean1_wew, avg => mean2_wew, enable_out => enable1);
odchylenie: 	  liczenie_odchylenia  port map (CLK => CLK, RESET => RESET, enable => enable1, avg => mean1_wew, gen =>gen0, dev =>dev_wew);


gen <= gen0;
mean1 <= mean1_wew;
mean2 <= mean2_wew;
dev <= dev_wew;


end calosc_arch;
