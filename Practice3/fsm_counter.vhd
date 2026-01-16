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

    signal count1 : STD_LOGIC_VECTOR (3 downto 0);
    signal count2 : STD_LOGIC_VECTOR (3 downto 0);

    type FSM_state is (S0, S1);
    signal state : FSM_state;

    signal div_cnt : integer range 0 to DIV_MAX; 
    signal clk_en  : std_logic;                  

begin

    -- ========= 除頻器 =========
    CLK_DIVIDER_PROC: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            div_cnt <= 0;
            clk_en  <= '0';
        elsif rising_edge(i_clk) then
            if div_cnt = DIV_MAX then
                div_cnt <= 0;
                clk_en  <= '1'; 
            else
                div_cnt <= div_cnt + 1;
                clk_en  <= '0'; 
            end if;
        end if;
    end process;

    o_count1 <= count1;
    o_count2 <= count2;
-- ========= FSM  =========
    FSM: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            state <= S0;
            count1 <= (others => '0');
            count2 <= (others => '0');
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 
                case state is
                    when S0 =>
                        count2 <= (others => '0'); -- S0 期間 Counter 2 固定為 0
                        if count1 = "1001" then
                            count1 <= (others => '0'); 
                            count2 <= "1001";
                            state <= S1;
                       
                        else
                            count1 <= count1 + 1;
                            count2 <= (others => '0');
                        end if;
                        
                        
                    when S1 =>
                        count1 <= (others => '0'); -- S1 期間 Counter 1 固定為 0
                        if count2 = "0000" then 
                            count2 <= "1001";
                        elsif count2 = "0001" then
                            count2 <= (others => '0');
                            count1 <= "0001";
                            state <= S0;
                        else
                            count2 <= count2 - 1;
                            count1 <= "0000";
                        end if;
                        
    
                end case;
            end if;
        end if;
    end process;

 

end Behavioral;
