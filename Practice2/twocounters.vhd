library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity twocounters is
    Port (
        i_clk         : in  STD_LOGIC;
        i_rstp        : in  STD_LOGIC;
        i_direction1  : in  STD_LOGIC;  -- counter1 的方向 ('1' = up, '0' = down)
        i_direction2  : in  STD_LOGIC;  -- counter2 的方向
        o_ledc1       : out STD_LOGIC_VECTOR (7 downto 0);
        o_ledc2       : out STD_LOGIC_VECTOR (7 downto 0)
    );
end twocounters;

architecture Behavioral of twocounters is

    constant c_max : integer := 9;
    constant c_min : integer := 0;

    signal r_count1 : integer range 0 to 9 := 0;
    signal r_count2 : integer range 0 to 9 := 0;

begin

    -- Counter 1
    process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_count1 <= c_min;
        elsif rising_edge(i_clk) then
            if i_direction1 = '1' then  -- up
                if r_count1 < c_max then
                    r_count1 <= r_count1 + 1;
                else
                    r_count1 <= c_min;
                end if;
            else  -- down
                if r_count1 > c_min then
                    r_count1 <= r_count1 - 1;
                else
                    r_count1 <= c_max;
                end if;
            end if;
        end if;
    end process;

    -- Counter 2
    process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_count2 <= c_min;
        elsif rising_edge(i_clk) then
            if i_direction2 = '1' then  -- up
                if r_count2 < c_max then
                    r_count2 <= r_count2 + 1;
                else
                    r_count2 <= c_min;
                end if;
            else  -- down
                if r_count2 > c_min then
                    r_count2 <= r_count2 - 1;
                else
                    r_count2 <= c_max;
                end if;
            end if;
        end if;
    end process;

    o_ledc1 <= std_logic_vector(to_unsigned(r_count1, 8));
    o_ledc2 <= std_logic_vector(to_unsigned(r_count2, 8));

end Behavioral;
