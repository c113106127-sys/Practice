library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity twocounters is
    Port (
        i_clk         : in  STD_LOGIC;
        i_rstp        : in  STD_LOGIC;
        i_direction1  : in  STD_LOGIC;  
        i_direction2  : in  STD_LOGIC;
        i_limit_high  : in  STD_LOGIC_VECTOR (3 downto 0);
        i_limit_low   : in  STD_LOGIC_VECTOR (3 downto 0);
        o_led1       : out STD_LOGIC_VECTOR (3 downto 0);
        o_led2       : out STD_LOGIC_VECTOR (3 downto 0)
    );
end twocounters;

architecture Behavioral of twocounters is

    -- === 除頻器設定 ===
    -- 假設輸入 i_clk 為 50MHz，若要產生 1Hz (1秒跳一次)，計數到 50,000,000
    -- 這裡設定一個常數，你可以根據需求調整
    -- 125,000,000 次時鐘週期 = 1 秒
    constant CLK_DIV_VAL : integer := 125000000;-- 範例：0.5秒觸發一次 (50MHz下)
    signal r_div_cnt     : integer range 0 to CLK_DIV_VAL := 0;
    signal w_en          : std_logic := '0'; -- 觸發致能信號

    -- 計數器信號
    signal r_count1 : unsigned(3 downto 0) := (others => '0');
    signal r_count2 : unsigned(3 downto 0) := (others => '0');
    
    signal w_max : unsigned(3 downto 0);
    signal w_min : unsigned(3 downto 0);

begin
    w_max <= unsigned(i_limit_high);
    w_min <= unsigned(i_limit_low);

    -- [除頻器邏輯]
    -- 產生一個週期性的脈衝，讓計數器不再隨每個時鐘週期跳動
    clk_divider: process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_div_cnt <= 0;
            w_en <= '0';
        elsif rising_edge(i_clk) then
            if r_div_cnt = CLK_DIV_VAL - 1 then
                r_div_cnt <= 0;
                w_en <= '1'; -- 達到數值時產生一個週期的 High
            else
                r_div_cnt <= r_div_cnt + 1;
                w_en <= '0';
            end if;
        end if;
    end process;

    -- Counter 1
    count1: process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then 
            r_count1 <= (others => '0'); 
        elsif rising_edge(i_clk) then
            -- 只有在 w_en 為 '1' 時才執行計數動作
            if w_en = '1' then
                if i_direction1 = '1' then  
                    if r_count1 < w_max then
                        r_count1 <= r_count1 + 1;
                    else
                        r_count1 <= w_min;
                    end if;
                else  
                    if r_count1 > w_min then
                        r_count1 <= r_count1 - 1;
                    else
                        r_count1 <= w_max;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Counter 2
    count2: process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            r_count2 <= "1001";
        elsif rising_edge(i_clk) then
            -- 同樣受 w_en 控制
            if w_en = '1' then
                if i_direction2 = '1' then  
                    if r_count2 < w_max then
                        r_count2 <= r_count2 + 1;
                    else
                        r_count2 <= w_min;
                    end if;
                else  
                    if r_count2 > w_min then
                        r_count2 <= r_count2 - 1;
                    else
                        r_count2 <= w_max;
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_led1 <= std_logic_vector(r_count1);
    o_led2 <= std_logic_vector(r_count2);

end Behavioral;
