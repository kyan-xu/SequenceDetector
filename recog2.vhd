LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY recog2 is 
PORT( 
  x: IN STD_ULOGIC; 
  clk: IN STD_ULOGIC; 
  reset: IN STD_ULOGIC; 
  y: OUT STD_ULOGIC); 
END; 

ARCHITECTURE arch_mealy OF recog2 IS
  TYPE state_type is (INIT, FIRST, SECOND); -- List states
  SIGNAL curState, nextState: STATE_TYPE; 
  SIGNAL cnt0, nextCnt0: INTEGER RANGE 0 TO 14:=0; --Counter for 0
  SIGNAL cnt1, nextCnt1: INTEGER RANGE 0 TO 16:=0; --Counter for 1
BEGIN 
  combi_nextState: PROCESS(curState, x, cnt0, cnt1) -- Start combinational processes
  BEGIN 
    nextState <= curState;
    nextCnt0 <= cnt0;
    nextCnt1 <= cnt1;
    y = '0';
    CASE curState IS 
      WHEN INIT =>  -- State S0
        IF x = '1' THEN  -- When input is 1
          nextState <= INIT; 
        ELSE 
          nextState <= FIRST;
          nextCnt0 <= 0; -- set the nextCnt0 to 0
      WHEN FIRST =>  --State S1
        IF x = '0' THEN  --When input is 0
          nextState <= FIRST; -- Stay in the first, but the 0 increased
          IF cnt0 < 14 THEN  -- When the counted 0 is less than 15
            nextCnt0 <= cnt0 + 1; -- Number of 0 + 1
          ELSE 
            nextCnt0 <= 14;
          END IF;
        ELSE 
          IF cnt0 = 14 THEN
            nextState <= SECOND; -- Transit to S2
            nextCnt1 <= 0; -- Set the nextCnt1 to 0
          ELSE
            nextState = INIT; -- Transit to S0
          END IF;
        nextCnt0 <= 0; --Set nextCnt0 back to 0
        End IF;
      WHEN SECOND => --State S2
        IF x = '0' THEN
          nextState => FIRST; -- Back to S1
        ELSE 
          IF cnt1 < 16 THEN 
            nextCnt1 <= cnt1 + 1;
            nextState <= SECOND;
          ELSE
            y = '1' -- output is 1
            nextState <= INIT;
          END IF;
        END IF;
    END CASE;
  END PROCESS;

seq_state: PROCESS(clk, reset) -- Set up sequential processes
BEGIN 
  IF reset = '1' THEN
    curState <= INIT;
    cnt0 <= 0;
  ELSIF clk'event AND clk = '1' THEN -- Update at rising edge of clock
    curState = nextState;
    cnt0 <= nextCnt0;
    cnt1 <= nextCnt1;
  END IF 
END PROCESS -- End sequential processes

END -- End mealy FSM

      
