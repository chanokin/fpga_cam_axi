
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Address_Generator_v4 is
    Port ( 	CLK25      : in  STD_LOGIC;
            enable     : in  STD_LOGIC;								-- horloge de 25 MHz et signal d'activation respectivement
            vsync      : in  STD_LOGIC;
            hsync      : in  STD_LOGIC;
            address    : out STD_LOGIC_VECTOR (16 downto 0);
            row_count  : out STD_LOGIC_VECTOR (7 downto 0);
            col_count  : out STD_LOGIC_VECTOR (8 downto 0)
--			even_line_out: out STD_LOGIC;
--			address_raw: out STD_LOGIC_VECTOR(18 downto 0);
--			col_counter_out: out STD_LOGIC_VECTOR(9 downto 0)
		  );	-- adresse g�n�r�
end Address_Generator_v4;

architecture Behavioral of Address_Generator_v4 is


signal val: STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
signal row: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal col: STD_LOGIC_VECTOR (8 downto 0) := (others => '0');

begin
    address   <= val(16 downto 0);
    row_count <= row(7 downto 0);
    col_count <= col(8 downto 0);
	process(CLK25)
		begin
        if rising_edge(CLK25) then
            if (enable='1') then													-- si enable = 0 on arrete la g�n�ration d'adresses

                 if (val < 320*240) then										-- si l'espace m�moire est balay� compl�tement
                     val <= val + 1;
                     
                     if (col = 318) then
                        row <= row + 1;
                     end if;
                     
                     if (col < 319) then
                        col <= col + 1;
                     else
                        col <= (others => '0');
                     end if;
                      
                 end if;
                 
            end if;
        
            if vsync = '0' then 
               val <= (others => '0');
               row <= (others => '0');
               col <= (others => '0');
            end if;
        
        end if;	
    end process;
end Behavioral;

