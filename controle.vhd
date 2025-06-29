library ieee;
use ieee.std_logic_1164.all;

entity controle is
    port (
        BTN1, BTN0, clock_50        : in std_logic;
        end_game, end_time, end_round : in std_logic;
        R1, E1, E2, E3, E4, E5, E6   : out std_logic
    );
end entity;

architecture arc of controle is
    type State is (Start, Setup, Play_FPGA, Play_User, Next_Round, Check, Waits, Result);
    signal EA, PE: State := Start;
begin

    
    process (clock_50, BTN0)
    begin
        if BTN0 = '0' then
            EA <= Start;
        elsif rising_edge(clock_50) then
            EA <= PE;
        end if;
    end process;

    
    process (EA, BTN1, BTN0, end_game, end_time, end_round)
    begin
        
        R1 <= '0'; E1 <= '0'; E2 <= '0'; E3 <= '0';
        E4 <= '0'; E5 <= '0'; E6 <= '0';

        case EA is
            when Start =>
                PE <= Setup;

            when Setup =>
                E1 <= '1';
                if BTN1 = '1' then
                    PE <= Play_FPGA;
                else
                    PE <= Setup;
                end if;

            when Play_FPGA =>
                E2 <= '1';
                if BTN1 = '1' then
                    PE <= Play_User;
                else
                    PE <= Play_FPGA;
                end if;

            when Play_User =>
                E3 <= '1';
                if end_time = '1' then
                    PE <= Result;
                elsif BTN1 = '1' then
                    PE <= Next_Round;
                else
                    PE <= Play_User;
                end if;

            when Next_Round =>
                E4 <= '1';
                PE <= Check;

            when Check =>
                E5 <= '1';
                if end_game = '1' or end_round = '1' then
                    PE <= Result;
                else
                    PE <= Waits;
                end if;

            when Waits =>
                E6 <= '1';
                if BTN1 = '1' then
                    PE <= Play_FPGA;
                else
                    PE <= Waits;
                end if;

            when Result =>
                R1 <= '1';
                if BTN1 = '1' then
                    PE <= Start;
                else
                    PE <= Result;
                end if;

        end case;
    end process;
end architecture;