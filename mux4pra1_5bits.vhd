library ieee;
use ieee.std_logic_1164.all;

entity mux4pra1_5bits is
    port (
        F1, F2, F3, F4 : in  std_logic_vector(4 downto 0);
        sel           : in  std_logic_vector(1 downto 0);
        F             : out std_logic_vector(4 downto 0)
    );
end mux4pra1_5bits;

architecture arch of mux4pra1_5bits is
begin
    F <= F1 when sel = "00" else
         F2 when sel = "01" else
         F3 when sel = "10" else
         F4;
end arch;
