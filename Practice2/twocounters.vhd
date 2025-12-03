library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity twocounters is
    Port ( 
        i_clk        : in  STD_LOGIC; 
        i_rstp        : in  STD_LOGIC; 

        -- === 計數器 1 的介面 ===
        i_c1_enable  : in  STD_LOGIC; 
        i_c1_direction     : in  STD_LOGIC; 
        i_c1_max     : in  integer range 0 to 255; 
        i_c1_min     : in  integer range 0 to 255; 
        o_ledc1     : out STD_LOGIC_VECTOR (7 downto 0); 

        -- === 計數器 2 的介面 ===
        i_c2_enable  : in  STD_LOGIC; 
        i_c2_direction     : in  STD_LOGIC; 
        i_c2_max     : in  integer range 0 to 255; 
        i_c2_min     : in  integer range 0 to 255; 
        o_ledc2     : out STD_LOGIC_VECTOR (7 downto 0) 
    );
end twocounters;
architecture Behavioral of twocounters is

    signal r_count1 : integer range 0 to 255 := 0;
    signal r_count2 : integer range 0 to 255 := 0;
begin

    -- Process A: 計數器 1
    process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_count1 <= 0; 
        elsif rising_edge(i_clk) then
            if i_c1_enable = '1' then
                if i_c1_direction = '1' then
                    if r_count1 < i_c1_max then
                        r_count1 <= r_count1 + 1; 
                    else
                        r_count1 <= i_c1_min;       
                    end if;
                else
                    if r_count1 > i_c1_min then
                        r_count1 <= r_count1 - 1; 
                    else
                        r_count1 <= i_c1_max;       
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Process B: 計數器 2
    process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_count2 <= 0;
        elsif rising_edge(i_clk) then
            if i_c2_enable = '1' then
                if i_c2_direction = '1' then
                    if r_count2 < i_c2_max then
                        r_count2 <= r_count2 + 1;
                    else
                        r_count2 <= i_c2_min;
                    end if;
                else
                    if r_count2 > i_c2_min then
                        r_count2 <= r_count2 - 1;
                    else
                        r_count2 <= i_c2_max;
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_ledc1 <= std_logic_vector(to_unsigned(r_count1, 8));
    o_ledc2 <= std_logic_vector(to_unsigned(r_count2, 8));

end Behavioral;
