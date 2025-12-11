library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity twocounters_tb is
end twocounters_tb;

architecture Behavioral of twocounters_tb is

    signal i_clk       : std_logic := '0';
    signal i_rstp      : std_logic := '0';
    signal i_direction1: std_logic := '1';
    signal i_direction2: std_logic := '0';
    signal o_ledc1     : std_logic_vector(7 downto 0);
    signal o_ledc2     : std_logic_vector(7 downto 0);

begin

    clk_proc: process
    begin
        i_clk <= '0';
        wait for 5 ns;
        i_clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        i_rstp <= '1';
        wait for 20 ns;
        i_rstp <= '0';
        i_direction1 <= '1';
        i_direction2 <= '0';
        wait;
    end process;

    uut: entity work.twocounters
        port map (
            i_clk        => i_clk,
            i_rstp       => i_rstp,
            i_direction1 => i_direction1,
            i_direction2 => i_direction2,
            o_ledc1      => o_ledc1,
            o_ledc2      => o_ledc2
        );

end Behavioral;
