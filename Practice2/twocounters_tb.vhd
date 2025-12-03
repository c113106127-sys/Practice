library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_twocounters is
-- Testbench 本身沒有腳位，所以是空的
end tb_twocounters;

architecture behavior of tb_twocounters is 

    -- 1. 更新 Component 名稱與主程式一致
    component twocounters
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        
        c1_enable : in STD_LOGIC;
        c1_dir    : in STD_LOGIC;
        c1_max    : in integer;
        c1_min    : in integer;
        c1_out    : out STD_LOGIC_VECTOR(7 downto 0);
        
        c2_enable : in STD_LOGIC;
        c2_dir    : in STD_LOGIC;
        c2_max    : in integer;
        c2_min    : in integer;
        c2_out    : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;
    
    -- 內部訊號宣告
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal c1_enable : std_logic := '0';
    signal c1_dir    : std_logic := '0';
    signal c1_max    : integer := 255;
    signal c1_min    : integer := 0;
    signal c1_out    : std_logic_vector(7 downto 0);

    signal c2_enable : std_logic := '0';
    signal c2_dir    : std_logic := '0';
    signal c2_max    : integer := 255;
    signal c2_min    : integer := 0;
    signal c2_out    : std_logic_vector(7 downto 0);

    constant clk_period : time := 20 ns;

begin

    -- 2. 更新實例化名稱 (uut: twocounters)
    uut: twocounters PORT MAP (
          clk => clk,
          rst => rst,
          c1_enable => c1_enable,
          c1_dir => c1_dir,
          c1_max => c1_max,
          c1_min => c1_min,
          c1_out => c1_out,
          c2_enable => c2_enable,
          c2_dir => c2_dir,
          c2_max => c2_max,
          c2_min => c2_min,
          c2_out => c2_out
        );

    -- 時脈產生
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 測試劇本
    stim_proc: process
    begin		
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        
        -- 設定 C1 (上數 2~5)
        c1_min <= 2;
        c1_max <= 5;
        c1_dir <= '1'; 
        c1_enable <= '1';
        
        -- 設定 C2 (下數 8~10)
        c2_min <= 8;
        c2_max <= 10;
        c2_dir <= '0'; 
        c2_enable <= '1';

        wait for 200 ns;

        c1_dir <= '0'; -- C1 反向
        wait for 100 ns;

        c1_enable <= '0';
        c2_enable <= '0';
        
        wait;
    end process;

end behavior;
