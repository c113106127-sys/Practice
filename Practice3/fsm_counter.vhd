library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity practice3 is
    Generic (
        DIV_MAX : integer := 49999999 
    );
    Port (
        i_clk    : in STD_LOGIC;
        i_rst    : in STD_LOGIC;
        o_count1 : out STD_LOGIC_VECTOR (3 downto 0);
        o_count2 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end practice3;

architecture Behavioral of practice3 is

    signal div_cnt : std_logic_vector(25 downto 0); 
    signal clk_en  : std_logic;

    signal count1  : STD_LOGIC_VECTOR (3 downto 0);
    signal count2  : STD_LOGIC_VECTOR (3 downto 0);
    type FSM_state is (S0, S1);
    signal state   : FSM_state;

begin

    -- ========= 1. 除頻器 (維持原樣) =========
    CLK_DIVIDER_PROC: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            div_cnt <= (others => '0');
            clk_en  <= '0';
        elsif rising_edge(i_clk) then
            if div_cnt = std_logic_vector(to_unsigned(DIV_MAX, 26)) then
                div_cnt <= (others => '0');
                clk_en  <= '1'; 
            else
                div_cnt <= div_cnt + 1; 
                clk_en  <= '0'; 
            end if;
        end if;
    end process;

    o_count1 <= count1;
    o_count2 <= count2;

    FSM: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            state <= S0;
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 
                case state is
                    when S0 =>
                        if count1 = "1001" then
                            state <= S1;
                        end if;
                    when S1 =>
                        if count2 = "0001" then 
                            state <= S0;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- ========= 3. Counter 1 行為 =========
    counter1_proc: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count1 <= "0000";
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 
                if (state = S1 and count2 = "0001") then
                    count1 <= "0000"; 
                elsif state = S0 then
                    if count1 = "1001" then
                        count1 <= "0000";
                    else
                        count1 <= count1 + 1;
                    end if;
                else
                    count1 <= "0000";
                end if;
            end if;
        end if;
    end process;

    -- ========= 4. Counter 2 行為=========
    counter2_proc: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count2 <= "0000";
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 
                if (state = S0 and count1 = "1001") then
                    count2 <= "1001"; 
                elsif state = S1 then
                    if count2 = "0001" then
                        count2 <= "0000";
                    else
                        count2 <= count2 - 1;
                    end if;
                else
                    count2 <= "0000";
                end if;
            end if;
        end if;
    end process;

end Behavioral;
