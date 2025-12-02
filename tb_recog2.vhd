LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_recog2 IS
END tb_recog2;

ARCHITECTURE behav OF tb_recog2 IS
  COMPONENT recog2 
    PORT (
      x: IN STD_LOGIC;
      clk: IN STD_LOGIC;
      reset: IN STD_LOGIC;
      y: OUT STD_LOGIC
          );
  END COMPONENT;
  
  SIGNAL clk: STD_LOGIC := '0';
  SIGNAL reset: STD_LOGIC := '0';
  SIGNAL x: STD_LOGIC := '0';
  SIGNAL y: STD_LOGIC;
  CONSTANT clk_period: TIME := 10 ns;

BEGIN
  clk_process: PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR clk_period/2;
    clk <= '1';
    WAIT FOR clk_period/2;
  END PROCESS;

  
  stim_proc: PROCESS
  BEGIN 
    reset <= '1';
    WAIT FOR 25 ns;
    reset <= '0';

    FOR i IN 0 TO 14 LOOP -- 15 '0's
    x <= '0';
    WAIT FOR clk_period;
    END LOOP;
    
    FOR i IN 0 TO 16 LOOP -- 17 '1's
    x <= '1';
    WAIT FOR clk_period;
    END LOOP;
   
    WAIT;
  END PROCESS;

  DUT: recog2
    PORT MAP(
      x => x,
      clk => clk,
      reset => reset,
      y => y
      );
END behav;
