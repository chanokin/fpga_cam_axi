
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RGB_v4 is
    Port ( Din    : in  STD_LOGIC_VECTOR (9 downto 0); --8-bit gray concat spike code
           low_up : in  STD_LOGIC;
		   Nblank : in  STD_LOGIC;
		   clk    : in  STD_LOGIC;
           R,G,B  : out STD_LOGIC_VECTOR (3  downto 0)
          );
end RGB_v4;

architecture Behavioral of RGB_v4 is
    signal spike_code: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
begin
    spike_code <= Din(1 downto 0);
    process(clk) begin
--        if rising_edge(clk) then
            if (Nblank = '1') then
                if (spike_code = "10") then
                    R <= "1111"; G <= "0000"; B <= "0000";
                elsif (spike_code = "01") then
                    R <= "0000"; G <= "1111"; B <= "0000";
                elsif (low_up = '0') then 
                    R <= Din(9 downto 6); G <= Din(9 downto 6); B <= Din(9 downto 6);
                else
                    R <= Din(5 downto 2); G <= Din(5 downto 2); B <= Din(5 downto 2);
                end if;
            else
                R <= "0000"; G <= "0000"; B <= "0000";
            end if;
        
--        end if;
    end process;
    
end Behavioral;

