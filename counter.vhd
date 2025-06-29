library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        R     : in  std_logic;
        E     : in  std_logic;
        clock : in  std_logic;
        count : out std_logic_vector(3 downto 0);
        flag  : out std_logic
    );
end counter;

architecture bhv of counter is
    signal cnt : unsigned(3 downto 0) := (others => '0');
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if R = '1' then
                cnt <= (others => '0');
            elsif E = '1' then
                if cnt = 15 then
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);
    flag  <= '1' when cnt = 15 else '0';
end bhv;