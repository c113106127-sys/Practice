library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity practice1 is
    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        en       : in  std_logic;
        up_cnt   : out std_logic_vector(3 downto 0);
        down_cnt : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of practice1 is
    constant MAX_VAL : unsigned(3 downto 0) := to_unsigned(9, 4);
    constant MIN_VAL : unsigned(3 downto 0) := to_unsigned(0, 4);

    signal up_reg    : unsigned(3 downto 0) := MIN_VAL;
    signal down_reg  : unsigned(3 downto 0) := MAX_VAL;
begin

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            up_reg   <= MIN_VAL;
            down_reg <= MAX_VAL;

        elsif rising_edge(clk) then
            if en = '1' then
                
                -- Up counter
                if up_reg = MAX_VAL then
                    up_reg <= MIN_VAL;
                else
                    up_reg <= up_reg + 1;
                end if;

                -- Down counter
                if down_reg = MIN_VAL then
                    down_reg <= MAX_VAL;
                else
                    down_reg <= down_reg - 1;
                end if;

            end if;
        end if;
    end process;

    up_cnt   <= std_logic_vector(up_reg);
    down_cnt <= std_logic_vector(down_reg);

end architecture;

