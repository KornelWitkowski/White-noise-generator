----------------------------------------------------------------------------------
-- Kornel Witkowski
-- 249642
-- 25.04.2020
-- Komponent generuj¹cy szum bia³y
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity generator is
    generic (N : integer);
	Port (   
	         SEED    : in unsigned (3 downto 0);   -- zmiana przebiegu generowanego sygna³u
			 RESET   : in STD_LOGIC;
			 CLK	 : in STD_LOGIC;
			 GEN     : out unsigned (N-1 downto 0) -- wygenerowany sygna³
		  );
end generator;

architecture generator_arch of generator is

signal seed1 : unsigned (N-1 downto 0);
signal seed2 : unsigned (N-1 downto 0);
signal seed3 : unsigned (N-1 downto 0);
signal seed4 : unsigned (N-1 downto 0);
signal tmp   : unsigned (N-1 downto 0);


begin


XORshift: process(clk, reset)

begin
	if (RESET = '0') then
	
	   if N = 16 then	 
	         
	       seed1 <= unsigned(to_unsigned(10000, 16)) + SEED;
           seed2 <= unsigned(to_unsigned(22190, 16))+ SEED;
           seed3 <= unsigned(to_unsigned(11455, 16))+ SEED;
           seed4 <= unsigned(to_unsigned(211, 16))+ SEED;
	       tmp <= (others => '0');
	       	           
	   elsif  N = 24 then
	   
	       seed1 <= unsigned(to_unsigned(1900078, 24))+ SEED;
           seed2 <= unsigned(to_unsigned(743190, 24))+ SEED;
           seed3 <= unsigned(to_unsigned(114423, 24))+ SEED;
           seed4 <= unsigned(to_unsigned(2174111, 24))+ SEED;
	       tmp <= (others => '0');
	       
	   elsif  N = 32 then
	
            seed1 <= unsigned(to_unsigned(974300078, 32))+ SEED;
            seed2 <= unsigned(to_unsigned(74319032, 32))+ SEED;
            seed3 <= unsigned(to_unsigned(114327423, 32))+ SEED;
            seed4 <= unsigned(to_unsigned(2140987411, 32))+ SEED;
            tmp <= (others => '0');
            
        end if;
        
        
	elsif (CLK'event and CLK = '1') then
	
	
	   if N = 16 then
	   
	        tmp <= seed1 xor (seed1(8 downto 0) & "0000000"  );                                                         
	        seed1 <= seed2;                                                                                                
	        seed2 <= seed3;                                                                                                   
	        seed3 <= seed4;                                                                                                   
	        seed4 <= (seed4 xor (("000000"  & seed4(15 downto 6))) ) xor (tmp xor (   tmp (9 downto 0) &  "000000"));
	        
	   elsif N = 24 then
	   
	        tmp <= seed1 xor (seed1(12 downto 0) & "00000000000"  );                                                         
	        seed1 <= seed2;                                                                                                
	        seed2 <= seed3;                                                                                                   
	        seed3 <= seed4;                                                                                                   
	        seed4 <= (seed4 xor (("000000"  & seed4(23 downto 6))) ) xor (tmp xor (   tmp (15 downto 0) &  "00000000"));    
	         
	   elsif N = 32 then
	   
		    tmp <= seed1 xor (seed1(16 downto 0) & "000000000000000"  );
            seed1 <= seed2;
            seed2 <= seed3;
            seed3 <= seed4; 
		    seed4 <= (seed4 xor (("000000000000000000000"  & seed4(31 downto 21))) ) xor (tmp xor ("0000"  & tmp (31 downto 4)));
		    
	   else
	       seed4 <= (others => '0');
	   end if;
	end if;
	
end process XORshift;

GEN <= tmp;


end generator_arch;
