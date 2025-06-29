library ieee;
use ieee.std_logic_1164.all;
entity reg5bits is port (
CLK, RST, enable: in std_logic;
D: in std_logic_vector(4 downto 0);
Q: out std_logic_vector(4 downto 0)
);
end reg5bits;
architecture behv of reg5bits is
begin
process(CLK, D, RST, enable)
begin
if RST = '0' then
Q <= "00000";
elsif CLK'event and CLK = '1' then
if enable = '0' then
Q <= D;
end if;
end if;
end process;
end behv;