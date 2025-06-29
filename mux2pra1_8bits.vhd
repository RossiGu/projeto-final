library ieee;
use ieee.std_logic_1164.all;

entity mux2pra1_8bits is
    port (
        sel   : in  std_logic;
        x, y  : in  std_logic_vector(7 downto 0);
        saida : out std_logic_vector(7 downto 0)
    );
end mux2pra1_8bits;

architecture arcmux2_1 of mux2pra1_8bits is
begin
    saida <= x when sel = '0' else y;
end arcmux2_1;