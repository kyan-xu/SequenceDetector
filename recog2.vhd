LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY recog2 IS
PORT( 
  x: IN bit; 
  clk: IN bit; 
  reset: IN bit; 
  y: OUT bit); 
END recog2; 

ARCHITECTURE myArch OF recog2 IS
  TYPE state_type is (INIT, FIRST, SECOND); -- List states
  SIGNAL curState, nextState: STATE_TYPE; 
  SIGNAL cnt0, nextCnt0: INTEGER RANGE 0 TO 15:=0; --Counter for 0
  SIGNAL cnt1, nextCnt1: INTEGER RANGE 0 TO 17:=0; --Counter for 1
BEGIN 
  combi_nextState: PROCESS(curState, x, cnt0, cnt1) -- Start combinational processes
  BEGIN 
    nextState <= curState;
    nextCnt0 <= cnt0;
    nextCnt1 <= cnt1;
    CASE curState IS 
      WHEN INIT =>  -- State S0
        IF x = '1' THEN  -- When input is 1
          nextState <= INIT; 
          y <= '0';
        ELSE 
          nextState <= FIRST;
          nextCnt0 <= 1; -- set the nextCnt0 to 0
          y <= '0';
	END IF;
      WHEN FIRST =>  --State S1
        IF x = '0' THEN  --When input is 0
          nextState <= FIRST; -- Stay in the first, but the 0 increased
	  y <= '0';
          IF cnt0 < 15 THEN  -- When the counted 0 is less than 15
            nextCnt0 <= cnt0 + 1; -- Number of 0 + 1
          ELSE 
            nextCnt0 <= 15;
          END IF;
        ELSE 
          IF cnt0 = 15 THEN
            nextState <= SECOND; -- Transit to S2
            nextCnt1 <= 1; -- Set the nextCnt1 to 1
	    y <= '0';
          ELSE
            nextState <= INIT; -- Transit to S0
            nextCnt0 <= 0;
            nextCnt1 <= 0;
	    y <= '0';
          END IF;
        End IF;
      WHEN SECOND => --State S2
        IF x = '0' THEN
          nextState <= FIRST; -- Back to S1
          nextCnt0  <= 0;
          nextCnt1  <= 0;
	  y <= '0';
        ELSE 
          IF cnt1 < 17 THEN 
            nextCnt1 <= cnt1 + 1;
            nextState <= SECOND;
	    y <= '0';
          ELSE
            y <= '1'; -- output is 1
            nextState <= INIT;
	    nextCnt0  <= 0;
            nextCnt1  <= 0;
          END IF;
        END IF;
    END CASE;
  END PROCESS;

seq_state: PROCESS(clk, reset) -- Set up sequential processes
BEGIN 
  IF reset = '0' THEN
    curState <= INIT;
    cnt0 <= 0;
    cnt1 <= 0;
  ELSIF clk'event AND clk = '1' THEN -- Update at rising edge of clock
    curState <= nextState;
    cnt0 <= nextCnt0;
    cnt1 <= nextCnt1;
  END IF; 
END PROCESS; -- End sequential processes

END myArch; -- End mealy FSM