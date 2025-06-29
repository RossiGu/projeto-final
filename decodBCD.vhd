library IEEE;
use IEEE.Std_Logic_1164.all;

entity decodBCD is
    port (
        input  : in  std_logic_vector(3 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end decodBCD;

architecture comportamento of decodBCD is
begin
    output <= "00000001" when input = "0000" else
              "00000010" when input = "0001" else
              "00000100" when input = "0010" else
              "00001000" when input = "0011" else
              "00010000" when input = "0100" else
              "00100000" when input = "0101" else
              "01000000" when input = "0110" else
              "10000000" when input = "0111" else
              "00000000";
end comportamento;