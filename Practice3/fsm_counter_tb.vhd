library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_practice3 is
-- Testbench 不需要 Port
end tb_practice3;

architecture Behavioral of tb_practice3 is

    COMPONENT practice3
    GENERIC(
        DIV_MAX : integer
    );
    PORT(
        i_clk : IN  std_logic;
        i_rst : IN  std_logic;
        o_count1 : OUT  std_logic_vector(3 downto 0);
        o_count2 : OUT  std_logic_vector(3 downto 0)
    );
    END COMPONENT;

    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal o_count1 : std_logic_vector(3 downto 0);
    signal o_count2 : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: practice3
    GENERIC MAP (
        DIV_MAX => 4 
    )
    PORT MAP (
        i_clk => i_clk,
        i_rst => i_rst,
        o_count1 => o_count1,
        o_count2 => o_count2
    );

 
    clk_process :process
    begin
        i_clk <= '0';
        wait for clk_period/2;
        i_clk <= '1';
        wait for clk_period/2;
    end process;

 
    stim_proc: process
    begin		

        i_rst <= '0';
        wait for 100 ns;	

        i_rst <= '1';


        wait for 1000 ns; 
        
        assert false report "Simulation Finished" severity failure;
        
        wait;
    end process;

end Behavioral;
