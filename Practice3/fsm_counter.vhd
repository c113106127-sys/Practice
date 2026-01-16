
o_count1 <= count1;
o_count2 <= count2;

-- ========= FSM  =========
FSM: process(i_clk, i_rst)
begin
    if i_rst = '0' then
        state <= S0;
           
    elsif rising_edge(i_clk) then
        if clk_en = '1' then 
case state is

when S0 =>                       
    if count1 = "1001" then
        state <= S1;              
    end if;
               
when S1 =>
    if count2 = "0001" then 
        state <= S0;
                       
end if;   
end case;
end if;
end if;
end process;

 -- ========= Counter 1=========
    counter1: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count1 <= "0000";
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 
  
                if count1 = "1001" then
                    count1 <= "0000";
                else
              
                    count1 <= count1 + 1; 
                    count2 <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    -- ========= Counter 2 =========
    counter2: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count2 <= "0000"; 
        elsif rising_edge(i_clk) then
            if clk_en = '1' then 

               if count2 = "0000" then
                    count2 <= "1001";
                else
   
                    count2 <= count2 - 1;
                    count2 <= (others => '0');
                end if;
            end if;
        end if;
    end process;  
end Behavioral;
