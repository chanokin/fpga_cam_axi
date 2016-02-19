----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2015 12:30:52 AM
-- Design Name: 
-- Module Name: threshold - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity dvs_threshold_v4 is
    Port ( clk_in   : in STD_LOGIC;
           pix_in : in STD_LOGIC_VECTOR (7 downto 0);
           ref_in : in STD_LOGIC_VECTOR (9 downto 0);
           thresh   : in STD_LOGIC_VECTOR (7 downto 0);
           ref_out : out STD_LOGIC_VECTOR (9 downto 0) := (others => '0')--; valid_data: in STD_LOGIC
          );
end dvs_threshold_v4;

architecture Behavioral of dvs_threshold_v4 is

begin

    process(clk_in)
    begin
        if rising_edge(clk_in)then -- and valid_data = '1' then
            if (signed('0' & pix_in) - signed('0' & ref_in(9 downto 2))) > signed('0' & thresh) then
               ref_out <= pix_in & "01";
            elsif -(signed('0' & pix_in) - signed('0' & ref_in(9 downto 2))) > signed('0' & thresh) then
               ref_out <= pix_in & "10";
            else
               ref_out <= ref_in(9 downto 2) & "00";
            end if;
--            if (signed('0' & pix_in(7 downto 2)) - signed('0' & ref_in(9 downto 4))) > signed('0' & thresh(7 downto 2)) then
--               ref_out <= pix_in & "01";
--            elsif -(signed('0' & pix_in(7 downto 2)) - signed('0' & ref_in(9 downto 4))) > signed('0' & thresh(7 downto 2)) then
--               ref_out <= pix_in & "10";
--            else
--               ref_out <= ref_in(9 downto 2) & "00";
--            end if;
        end if;
    end process;
end Behavioral;


