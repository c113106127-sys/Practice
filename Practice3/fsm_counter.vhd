library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity practice3 is
    Port (
        i_clk    : in STD_LOGIC;
        i_rst    : in STD_LOGIC;
        o_count1 : out STD_LOGIC_VECTOR (3 downto 0);
        o_count2 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end practice3;

architecture Behavioral of practice3 is

    signal count1 : STD_LOGIC_VECTOR (3 downto 0);
    signal count2 : STD_LOGIC_VECTOR (3 downto 0);

    type FSM_state is (S0, S1);
    signal state : FSM_state;

    -- ========= 除頻器宣告 =========
    signal div_cnt : integer range 0 to 49999999;
    signal clk_div : STD_LOGIC;

begin
    o_count1 <= count1;
    o_count2 <= count2;

    -- ========= 除頻器 (50MHz → 1Hz) =========
    clk_divider : process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            div_cnt <= 0;
            clk_div <= '0';
        elsif rising_edge(i_clk) then
            if div_cnt = 49999999 then
                div_cnt <= 0;
                clk_div <= not clk_div;
            else
                div_cnt <= div_cnt + 1;
            end if;
        end if;
    end process;

    -- ========= FSM =========
    FSM: process(clk_div, i_rst)
    begin
        if i_rst = '0' then
            state <= S0;
        elsif rising_edge(clk_div) then
            case state is
                when S0 =>
                    if count1 = "1001" then
                        state <= S1;
                    end if;

                when S1 =>
                    if count2 = "1001" then
                        state <= S0;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

    -- ========= Counter 1 =========
    counter1: process(clk_div, i_rst)
    begin
        if i_rst = '0' then
            count1 <= "0000";
        elsif rising_edge(clk_div) then
            case state is
                when S0 =>
                    if count1 < "1001" then
                        count1 <= count1 + 1;
                    end if;

                when S1 =>
                    count1 <= "0000";

                when others =>
                    null;
            end case;
        end if;
    end process;

    -- ========= Counter 2 =========
    counter2: process(clk_div, i_rst)
    begin
        if i_rst = '0' then
            count2 <= "0000";
        elsif rising_edge(clk_div) then
            case state is
                when S0 =>
                    count2 <= "0000";

                when S1 =>
                    if count2 < "1001" then
                        count2 <= count2 + 1;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;
