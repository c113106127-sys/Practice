library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- 建議將 std_logic_unsigned 替換為 numeric_std 的無號數，但為了保持與您原始程式碼的一致性，暫時保留。
-- use ieee.std_logic_unsigned.all; 

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
    -- 兩個 4-bit BCD 計數器的暫存器
    signal up_reg    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal down_reg  : STD_LOGIC_VECTOR(3 downto 0) := "1001";

    -- --- 新增除頻器訊號 ---
    -- 50MHz / 25,000,000 = 2Hz (週期 0.5s)；所以需要 25,000,000-1。
    -- 需要 25 bits: 2^24 = 16,777,216; 2^25 = 33,554,432
    constant DIV_MAX : natural := 24999999; -- 計數 25,000,000 次
    signal div_cnt   : unsigned(24 downto 0) := (others => '0');
    signal div_clk       : std_logic := '0'; -- 1 Hz 的慢速時脈
    -- ----------------------

begin   

    -- ###########################################################
    -- ? 1. 除頻器 (Clock Divider)
    -- 產生一個慢速時脈 (1 Hz)
    -- ###########################################################
    DIV: process(i_clk, i_rstp)
    begin
        if i_rstp = '1' then
            div_cnt <= (others => '0');
            div_clk     <= '0';
        elsif rising_edge(i_clk) then
            if div_cnt = to_unsigned(DIV_MAX, div_cnt'length) then
                div_cnt <= (others => '0'); -- 重置計數器
                div_clk     <= not div_clk;     -- 翻轉時脈，週期 1s (50M/25M = 2次/s)
            else
                div_cnt <= div_cnt + 1; -- 繼續計數
            end if;
        end if;
    end process;
    

    -- ###########################################################
    -- ? 2. 計數器 UP (現在使用慢速時脈 clk_1hz)
    -- ###########################################################
    UP :process(div_clk, i_rstp) 
    begin       
        -- 注意: 現在使用慢速時脈 clk_1hz 作為敏感列表
        if i_rstp = '1' then             
            up_reg <= "0000";
        elsif rising_edge(i_clk) then
            if i_enable = '1' then    
                -- BCD 計數 0000 到 1001 (0到9)
                if up_reg = "1001" then
                    up_reg <= "0000";
                else
                    -- **注意**: 由於您使用了 std_logic_unsigned，我們保留 up_reg + 1 的寫法。
                    -- 若使用 numeric_std，標準寫法應為: up_reg <= std_logic_vector(unsigned(up_reg) + 1);
                    up_reg <= up_reg + 1; 
                end if;
            end if;
        end if;
    end process;    

    -- ###########################################################
    -- ? 3. 計數器 DOWN (現在使用慢速時脈 clk_1hz)
    -- ###########################################################
    DOWN: process(div_clk, i_rstp) 
    begin      
        -- 注意: 現在使用慢速時脈 clk_1hz 作為敏感列表
        if i_rstp = '1' then 
            down_reg <= "1001";       
        elsif rising_edge(i_clk) then
            if i_enable = '1' then
                -- BCD 計數 1001 到 0000 (9到0)
                if down_reg = "0000" then
                    down_reg <= "1001";
                else
                    -- **注意**: 同上，保留 down_reg - 1 的寫法。
                    down_reg <= down_reg - 1;
                end if;
            end if;
        end if;
    end process;   

    -- ###########################################################
    -- ? 4. 輸出賦值
    -- ###########################################################
    o_ledup   <= up_reg;
    o_leddown <= down_reg;

end architecture;
