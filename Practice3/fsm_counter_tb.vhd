library IEEE;
use IEEE.std_logic_1164.all;

entity tb_practice3 is
end tb_practice3;

architecture sim of tb_practice3 is

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal c1     : std_logic_vector(7 downto 0);
    signal c2     : std_logic_vector(7 downto 0);

    component practice3
        Port (
            i_clk    : in STD_LOGIC;
            i_rst    : in STD_LOGIC;
            o_count1 : out STD_LOGIC_VECTOR (7 downto 0);
            o_count2 : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
begin
    UUT: practice3
        port map(
            i_clk    => clk,
            i_rst    => rst,
            o_count1 => c1,
            o_count2 => c2
        );

    -- clock 10ns
    clk <= not clk after 5 ns;
    process
    begin
        rst <= '0';
        wait for 20 ns;

        rst <= '1';
        wait for 400 ns;

        wait;
    end process;

end sim;
