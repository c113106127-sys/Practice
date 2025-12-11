library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity practice3 is
    Port (
        i_clk    : in STD_LOGIC;
        i_rst    : in STD_LOGIC;
        o_count1 : out STD_LOGIC_VECTOR (7 downto 0);
        o_count2 : out STD_LOGIC_VECTOR (7 downto 0)
    );
end practice3;

architecture Behavioral of practice3 is

    signal count1 : STD_LOGIC_VECTOR (7 downto 0);
    signal count2 : STD_LOGIC_VECTOR (7 downto 0);

    type FSM_state is (S0, S1);
    signal state : FSM_state;
begin
    o_count1 <= count1;
    o_count2 <= count2;

    FSM: process(i_clk, i_rst, count1, count2)
    begin
        if i_rst = '0' then
            state <= S0;
        elsif i_clk'event and i_clk = '1' then
            case state is
                when S0 =>
                    if count1 = "00001001" then
                        state <= S1;
                    end if;

                when S1 =>
                    if count2 = "00001011" then
                        state <= S0;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

    counter1: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count1 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            case state is
                when S0 =>
                    if count1 < "00001001" then
                        count1 <= count1 + 1;
                    else
                        count1 <= count1;  -- 保持 9
                    end if;

                when S1 =>
                    -- S1 時 count1 歸零
                    count1 <= "00000000";

                when others =>
                    null;
            end case;
        end if;
    end process;

    counter2: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count2 <= "00000010";  -- 從 2 開始
        elsif rising_edge(i_clk) then
            case state is
                when S0 =>
                    -- S0 時 count2 固定保持為 2
                    count2 <= "00000010";

                when S1 =>
                    if count2 < "00001011" then
                        count2 <= count2 + 1;  -- 遞增至 11
                    else
                        count2 <= count2;      -- 保持 11
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;
