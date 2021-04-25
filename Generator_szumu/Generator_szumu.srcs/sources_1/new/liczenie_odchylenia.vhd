----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Uk³ad do liczenia œredniego odchylenia bezwzglêdnego z 64 próbek
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity liczenie_odchylenia is
    generic (N : integer);
    Port ( RESET    : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           avg      : in unsigned (N-1 downto 0);
           gen      : in unsigned (N-1 downto 0);
           enable   : in STD_LOGIC;
           dev      : out unsigned (N-1 downto 0));
end entity liczenie_odchylenia;

architecture liczenie_odchylenia_arch of liczenie_odchylenia is

signal licznik : unsigned (6 downto 0);
signal suma : unsigned ((N-1)+6 downto 0);
signal start : STD_LOGIC;


begin

proces_start : process(enable, RESET) -- uk³ad bêdzie w³¹czany po wyliczeniu odpowiedniej œredniej

begin

    if RESET = '0' then
        start <= '0';
    elsif enable = '1' then
        start <= '1';
    end if;

end process proces_start;


proces_licznika : process(CLK, RESET)  

begin

	if (RESET = '0') then
        licznik <= (others => '0');
	elsif (CLK'event and CLK = '1') then
	   if start = '1' then
	       if licznik = 64 then
	            licznik <= "0000001"; 
	       else
                licznik <= licznik +1;
           end if;
       end if;
	end if;

end process proces_licznika;


proces_sumowania : process(CLK, RESET) 

begin

    if (RESET = '0') then
        suma <= (others => '0');
	elsif (CLK'event and CLK = '1') then
	   if start = '1' then
	       if licznik = 64 then
	           if avg > gen then
	               suma <= "000000" & (avg - gen);
	           else
	               suma <= "000000" & (gen  -avg) ;    
               end if;
           else
                if avg > gen then
                   suma <= suma + avg - gen;
                else
                   suma <= suma + gen - avg;
                end if;
           end if;  
       end if;
	end if;
	
end process proces_sumowania; 


proces_avg : process(licznik, RESET, CLK) 

begin

    if (RESET = '0') then
       dev <=  (others => '0');
    elsif (CLK'event and CLK = '1') then
        if licznik = 64 then        
                if (suma (5 downto 0) > 31) then
                   dev <=  suma ((N-1)+ 6 downto 6) + 1;  
                else  
                   dev <=  suma ((N-1)+ 6 downto 6);  
                end if;
        end if;        
    end if;
    
end process proces_avg;   


end architecture liczenie_odchylenia_arch;
