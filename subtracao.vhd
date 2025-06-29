library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity subtracao is
    port(
        A         : in  std_logic_vector(4 downto 0);
        B         : in  std_logic_vector(4 downto 0);
        resultado : out std_logic_vector(4 downto 0);
        flag      : out std_logic
    );
end subtracao;

architecture bhv of subtracao is
begin
    process(A, B)
    begin
        resultado <= A - B;
        if A < B then
            flag <= '1';
        else
            flag <= '0';
        end if;
    end process;
end bhv;