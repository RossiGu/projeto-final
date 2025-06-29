-- Datapath, fazendo a conexÃƒÂ£o entre cada componente

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port (
-- Entradas de dados
SW: in std_logic_vector(17 downto 0);
--CLOCK_50: in std_logic; --NA PLACA
CLOCK_50, CLK_1Hz: in std_logic; --NO EMULADOR
-- Sinais de controle
R1, E1, E2, E3, E4, E5, E6: in std_logic;
-- Sinais de status
end_game, end_time, end_round: out std_logic;
-- Saidas de dados
HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0);
LEDR: out std_logic_vector(17 downto 0)
);
end datapath;

architecture arc of datapath is
--============================================================--
--                      COMPONENTS                            --
--============================================================--
-------------------DIVISOR DE FREQUENCIA------------------------

component Div_Freq is
	port (	    clk: in std_logic;
				reset: in std_logic;
				CLK_1Hz: out std_logic
			);
end component;

------------------------CONTADORES------------------------------

component counter is port( 
         R: in std_logic;
         clock: in std_logic;
         E: in std_logic;
			count: out std_logic_vector(3 downto 0);
			flag: out std_logic);
end component;

-------------------ELEMENTOS DE MEMORIA-------------------------

component reg2bits is 
port(
    CLK, RST, enable: in std_logic;
    D: in std_logic_vector(1 downto 0);
    Q: out std_logic_vector(1 downto 0)
    );
end component;

component reg5bits is 
port(
    CLK, RST, enable: in std_logic;
    D: in std_logic_vector(4 downto 0);
    Q: out std_logic_vector(4 downto 0)
    );
end component;

component reg5bits_points is 
port (
	CLK, RST, enable: in std_logic;
	D: in std_logic_vector(5 downto 0);
	Q: out std_logic_vector(5 downto 0)
	);
end component;

component reg6bits_points is 
port(
    CLK, RST, enable: in std_logic;
	D: in std_logic_vector(5 downto 0);
	Q: out std_logic_vector(5 downto 0)
	);
end component;

component ROM0 is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(4 downto 0) );
end component;

component ROM1 is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(4 downto 0) );
end component;

component ROM2 is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(4 downto 0) );
end component;

component ROM3 is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(4 downto 0) );
end component;

---------------------MULTIPLEXADORES----------------------------


component mux2pra1_4bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(3 downto 0);
	saida: out std_logic_vector(3 downto 0)
    );
end component;

component mux2pra1_7bits is
port (sel: in std_logic;
		x, y: in std_logic_vector(6 downto 0);
		saida: out std_logic_vector(6 downto 0)
);
end component;

component mux2pra1_5bits is
port (sel: in std_logic;
		x, y: in std_logic_vector(4 downto 0);
		saida: out std_logic_vector(4 downto 0)
);
end component;

component mux2pra1_8bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(7 downto 0);
	saida: out std_logic_vector(7 downto 0)
    );
end component;

component mux2pra1_6bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(5 downto 0);
	saida: out std_logic_vector(5 downto 0)
    );
end component;

component mux4pra1_5bits is	
port (F1: in  std_logic_vector(4 downto 0);
 F2: in  std_logic_vector(4 downto 0);
 F3: in  std_logic_vector(4 downto 0);
 F4: in  std_logic_vector(4 downto 0);
 sel: in  std_logic_vector(1 downto 0);
 F: out  std_logic_vector(4 downto 0));
end component;


----------------------DECODIFICADOR-----------------------------

component decod7seg is
port(
    C: in std_logic_vector(3 downto 0);
    F: out std_logic_vector(6 downto 0)
    );
end component;

component decodtermo is
    port (
        X : in  std_logic_vector(4 downto 0);
        S : out std_logic_vector(17 downto 0)
    );
end component;

component decodBCD is port (
	input  : in  std_logic_vector(3 downto 0);
	output : out std_logic_vector(7 downto 0)
	);
end component;

-------------------COMPARADORES E SOMA--------------------------

component subtracao is port(
	A       : in  std_logic_vector(4 downto 0);
   B       : in  std_logic_vector(4 downto 0);
   resultado       : out std_logic_vector(4 downto 0);
	flag: out std_logic
    );
end component;

component somador is port (
    A: in  std_logic_vector(5 downto 0);
    B: in  std_logic_vector(5 downto 0);
    F: out  std_logic_vector(5 downto 0)
	 );
end component;

component comp2 is
    port (
        A       : in  std_logic_vector(4 downto 0);
        F       : out std_logic_vector(4 downto 0)
    );
end component;

--============================================================--
--                      SIGNALS                               --
--============================================================--

signal neg_flag, COMP_msb, CLK_1, SW17_and_E3, end_game_aux_or_end_time_aux, end_game_aux, end_time_aux, COMP_5, flag1, flag2, SW0orE5, cond_final: std_logic; -- 1 bit
signal SEL: std_logic_vector (1 downto 0); -- 2 bits
signal final_point_msb, final_point_lsb, round, timer, time_fpga_3_downto_0, FPGA_BCD_7_downto_4, FPGA_BCD_3_downto_0, time_BCD_7_downto_4, time_BCD_3_downto_0, mux_hex0, mux_hex1, end_game_aux_or_end_time_aux_extended, mux_hex0aux, mux_hex1aux, sel_aux: std_logic_vector (3 downto 0); -- 4 bits
signal final, t5bits, COMP, time_FPGA, ROM_out, ROM0_out, ROM1_out, ROM2_out, ROM3_out: std_logic_vector (4 downto 0); -- 5 bits
signal points, points_reg, double_neg_COMP, neg_COMP, penalty: std_logic_vector(5 downto 0);
signal dec_hex6, dec_hex7: std_logic_vector (6 downto 0);
signal time_BCD, FPGA_BCD, time_BCD_out: std_logic_vector (7 downto 0);
signal branco: std_logic_vector(6 downto 0) := "1111111";


begin


--DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- para uso na placa

-- a fazer pelo alun@
H0: reg2bits port map(CLOCK_50, R1, E1, SW(1 downto 0), SEL(1 downto 0));
H1: counter port map(R1, CLOCK_50, E4, round, end_round);
H2: ROM0 port map(round, ROM0_out);
H3: ROM1 port map(round, ROM1_out);
H4: ROM2 port map(round, ROM2_out);
H5: ROM3 port map(round, ROM3_out);
H6: mux4pra1_5bits port map(ROM0_out, ROM1_out, ROM2_out, ROM3_out, SEL(1 downto 0), ROM_out);
H7: reg5bits port map(CLOCK_50, R1, E2, ROM_out, time_FPGA);
SW17_and_E3 <= SW(17) and E3;
H8: counter port map(E2, SW17_and_E3, CLK_1Hz, timer, end_time);
t5bits <= ('0' & timer);
H9: subtracao port map(time_FPGA, t5bits, COMP, neg_flag);
end_game <= (neg_flag or points(5));
H10: mux2pra1_8bits port map(SW(0), "00000000", time_BCD, time_BCD_out);
double_neg_COMP <= ('0' & COMP);
neg_COMP <= std_logic_vector(unsigned(not ('0' & COMP)) + 1);
H11: mux2pra1_6bits port map(COMP(4), neg_COMP, double_neg_COMP, penalty);
H12: somador port map(penalty, points_reg, points);
H13: reg6bits_points port map(CLOCK_50, R1, E4, points, points_reg);
H14: decodBCD port map(timer, time_BCD);
H15: decodBCD port map(time_FPGA(3 downto 0), FPGA_BCD);
-- -------------------------------------------------------
-- MUX
end_game_aux <= neg_flag or points(5);
end_game <= end_game_aux;
end_time <= end_time_aux;
cond_final <= not(end_game_aux) and not(end_time_aux);
final <= points_reg(4 downto 0) when cond_final = '1' else (others => '0');
sel_aux <= '0' & SEL;
dec1: decod7seg port map(sel_aux, dec_hex7);
H16: mux2pra1_7bits port map(E6, branco, dec_hex7, HEX7);
dec2: decod7seg port map(final(3 downto 0), dec_hex6);
H17: mux2pra1_7bits port map(E6, branco, dec_hex6, HEX6);
HEX5 <= "0100110";
dec3: decod7seg port map(sel_aux, HEX4);
HEX3 <= "0111001";
dec4: decod7seg port map(round, HEX2);
SW0orE5 <= SW(0) or E5;
H18: mux2pra1_4bits port map(SW0orE5,"0000", time_BCD_out(7 downto 4), time_BCD_7_downto_4);
H19: mux2pra1_4bits port map(E2, time_BCD_7_downto_4, FPGA_BCD(7 downto 4), FPGA_BCD_7_downto_4);
dec5: decod7seg port map(FPGA_BCD_7_downto_4, HEX1);
H20: mux2pra1_4bits port map(SW0orE5,"0000", time_BCD_out(3 downto 0), time_BCD_3_downto_0);
H21: mux2pra1_4bits port map(E2, time_BCD_3_downto_0, FPGA_BCD(3 downto 0), FPGA_BCD_3_downto_0);
dec6: decod7seg port map(FPGA_BCD_3_downto_0, HEX0);
dec7: decodtermo port map(points_reg(4 downto 0), LEDR(17 downto 0));
end arc;