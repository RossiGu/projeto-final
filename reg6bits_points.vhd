library ieee;
use ieee.std_logic_1164.all;

entity reg6bits_points is
    port (
        CLK, RST, enable: in std_logic;
        D: in std_logic_vector(5 downto 0);
        Q: out std_logic_vector(5 downto 0)
    );
end reg6bits_points;

architecture behv of reg6bits_points is
begin
    process(CLK, D, RST, enable)
    begin
        if RST = '0' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            if enable = '0' then
                Q <= D;
            end if;
        end if;
    end process;
end behv;
