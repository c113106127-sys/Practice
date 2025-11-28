library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity practice1 is
    port (
        clk      : in  std_logic;
        rst_p    : in  std_logic; 
        en       : in  std_logic;
        up_cnt   : out std_logic_vector(3 downto 0);
        down_cnt : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of practice1 is
    
   
    signal up_reg    : integer := 0;
    signal down_reg  : integer := 9;

begin

   
    Up_Down Counter process(clk, rst_p) 
    begin
       
        if rst_p = '1' then 
            up_reg   <= 0;
            down_reg <= 9;

       
        elsif rising_edge(clk) then
            if en = '1' then

               
                if up_reg = 9 then
                    up_reg <= 0;
                else
                    up_reg <= up_reg + 1;
                end if;

               
                if down_reg = 0 then
                    down_reg <= 9;
                else
                    down_reg <= down_reg - 1;
                end if;

            end if;
        end if;
    end process;

   
    LED_up   <= std_logic_vector(to_unsigned(up_reg, 4));
    LED_down <= std_logic_vector(to_unsigned(down_reg, 4));

end architecture;
