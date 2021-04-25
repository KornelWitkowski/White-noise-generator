----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad do liczenia œredniej z 16 próbek
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity liczenie_sredniej is
    generic (N : integer);
    Port ( RESET        : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           enable_in    : in STD_LOGIC;                     -- sygna³ w³¹czaj¹cy zliczanie
           gen          : in unsigned (N - 1 downto 0) ;    -- wejœcie sygna³u generatora
           avg          : out unsigned (N - 1 downto 0);    -- wyliczona œrednia     
           enable_out   : out STD_LOGIC);                   -- sygna³ informuj¹cy dalsze uk³adu o zakoñczeniu liczenia
end entity liczenie_sredniej;

architecture liczenie_sredniej_arch of liczenie_sredniej is

signal licznik : unsigned (4 downto 0);
signal suma : unsigned ((N-1) + 4 downto 0);


begin

proces_licznika : process(CLK, RESET)  

begin

	if (RESET = '0') then
        licznik <= (others => '0');
	elsif (CLK'event and CLK = '1') then
	   if enable_in = '1' then
	       if licznik = 16 then
	            licznik <= "00001"; 
	       else
                licznik <= licznik +1;
           end if;
       end if;
	end if;
    
end process proces_licznika;


proces_enable_out : process(licznik, RESET, CLK) 

begin

    if (RESET = '0') then
        enable_out <= '0';
    elsif (CLK'event and CLK = '1') then
        if licznik = 16 then
           enable_out <= '1';
        else
           enable_out <= '0';    
        end if;
     end if;
    
end process proces_enable_out;    


proces_sumowania : process(CLK, RESET) 

begin

    if (RESET = '0') then
        suma <= (others => '0');
	elsif (CLK'event and CLK = '1') then
	   if enable_in = '1' then
	       if licznik = 16 then
            suma <= "0000" &   gen;
           else
              suma <= suma + gen;
           end if;
       end if;
	end if;
	
end process proces_sumowania; 


proces_avg : process(licznik, RESET, CLK) 

begin

    if (RESET = '0') then
       avg <=  (others => '0');
    elsif (CLK'event and CLK = '1') then
        if licznik = 16 then
                if (suma (3 downto 0) > 7) then
                   avg <=  suma ((N-1) + 4 downto 4) + 1;  
                else  
                   avg <=  suma ((N-1) + 4  downto 4);  
                end if;
        end if;    
    end if;
    
end process proces_avg; 


end architecture liczenie_sredniej_arch;
