library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity twocounters_tb is
end twocounters_tb;

architecture Behavioral of twocounters_tb is

    signal i_clk         : std_logic := '0';
    signal i_rstp        : std_logic := '1';
    signal i_direction1  : std_logic := '1';
    signal i_direction2  : std_logic := '0';
    signal i_limit_high  : std_logic_vector(3 downto 0) := x"9"; -- 預設上限 9
    signal i_limit_low   : std_logic_vector(3 downto 0) := x"0"; -- 預設下限 0
    signal o_led1       : std_logic_vector(3 downto 0);
    signal o_led2       : std_logic_vector(3 downto 0);

begin

    clk_proc: process
    begin
        i_clk <= '0';
        wait for 2.5 ns;
        i_clk <= '1';
        wait for 2.5 ns;
    end process;

    process
    begin
        -- 1. 先設定好數值，並等待一小段時間讓數值穩定
        i_limit_low  <= x"2"; 
        i_limit_high <= x"6";
        wait for 1 ns; -- 給予一個微小的延遲，確保 w_min 已經變成 3
        
        -- 2. 此時觸發復位，計數器才會抓到 3
        i_rstp <= '1';
        wait for 10 ns; -- 建議復位時間長一點，跨過一個時脈邊緣
        
        -- 3. 釋放復位
        i_rstp <= '0';
        
        wait for 180 ns;
        i_direction1 <= '0';
        i_direction2 <= '1';
        i_limit_low  <= x"4"; 
        i_limit_high <= x"8";
        -- 後續動作...
        wait;
    end process;

    uut: entity work.twocounters
        port map (
            i_clk        => i_clk,
            i_rstp       => i_rstp,
            i_direction1 => i_direction1,
            i_direction2 => i_direction2,
            i_limit_high => i_limit_high,
            i_limit_low  => i_limit_low,
            o_led1      => o_led1,
            o_led2      => o_led2
        );

end Behavioral;
