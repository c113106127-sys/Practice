library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_dual_counter is
end entity;

architecture tb of tb_dual_counter is
    signal clk      : std_logic := '0';
    signal rst_p    : std_logic := '0'; 
    signal en       : std_logic := '0';
    signal up_cnt   : std_logic_vector(3 downto 0);
    signal down_cnt : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;
begin

   
    uut: entity work.practice1
        port map (
            clk      => clk,
            rst_p    => rst_p,   
            en       => en,
            up_cnt   => up_cnt,
            down_cnt => down_cnt
        );

    ------------------------------------------------------------------
    -- Clock generator
    ------------------------------------------------------------------
    clk_proc: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    ------------------------------------------------------------------
    -- Stimulus
    ------------------------------------------------------------------
    stim_proc: process
    begin
        wait for 10 ns;
        
       
        rst_p <= '1'; 
        en    <= '0'; 
        wait for 2 * clk_period; 
        
       
        rst_p <= '0'; 
        en    <= '1'; 
        
        wait for 10 * clk_period; 
        
       
        en <= '0';
        wait for 5 * clk_period; 

        wait; 
    end process;

   
    monitor_proc: process(clk)
    begin
        if rising_edge(clk) then
            report "t=" & time'image(now) &
                     " | up="    & integer'image(to_integer(unsigned(up_cnt))) &
                     " | down=" & integer'image(to_integer(unsigned(down_cnt)));
        end if;
    end process;

end architecture;
