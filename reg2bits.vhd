library ieee;
use ieee.std_logic_1164.all;
entity D_FF is port (
CLK: in std_logic;
RST: in std_logic;
enable: in std_logic;
D: in std_logic;
Q: out std_logic
);
end D_FF;
architecture behv of D_FF is
begin
process (CLK, RST, D, enable)
begin
if RST = '0' then
Q <= '0';
elsif CLK'event and CLK = '1' then
if enable = '1' then
Q <= D;
end if;
end if;
end process;
end behv;