library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_unsigned.all; -- necessário para o +
entity somador is
port (A: in std_logic_vector(5 downto 0);
B: in std_logic_vector(5 downto 0);
F: out std_logic_vector(5 downto 0)
);
end somador;
architecture circuito of somador is
begin
F <= A + B;
end circuito;