library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity practice1 is
    port (
        i_clk      : in  std_logic;
        i_rstp    : in  std_logic; 
        i_enable       : in  std_logic;
        o_ledup   : out std_logic_vector(3 downto 0);
        o_leddown : out std_logic_vector(3 downto 0)
    );
end entity;
architecture rtl of practice1 is       
    signal up_reg    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal down_reg  : STD_LOGIC_VECTOR(3 downto 0) := "1001";
begin   
    UP :process(i_clk, i_rstp) 
    begin       
        if i_rstp = '1' then             
            up_reg <= "0000";
        elsif rising_edge(i_clk) then
            if i_enable = '1' then    
                if up_reg = "1001" then
                    up_reg <= "0000";
                else
                    up_reg <= up_reg + 1;
                end if;
            end if;
        end if;
    end process;    
    DOWN: process(i_clk, i_rstp) 
    begin      
        if i_rstp = '1' then 
            down_reg <= "1001";       
        elsif rising_edge(i_clk) then
            if i_enable = '1' then
                if down_reg = "0000" then
                    down_reg <= "1001";
                else
                    down_reg <= down_reg - 1;
                end if;
            end if;
        end if;
    end process;   
    o_ledup   <= up_reg;
    o_leddown <= down_reg;

end architecture;
