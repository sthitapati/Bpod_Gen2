% Example state matrix: A global timer in "loop mode" blinks port2 LED in an infinite loop. 
% It is triggered in the first state. Next, the state machine goes into a state
% where it waits for two events:
% 1. Port1In momentarily enters a state that stops the global timer. Port 2 will stop blinking.
% 2. Exits the state machine.

sma = NewStateMachine;
sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', 0.5, 'OnsetDelay', 0.5,...
                     'Channel', 'PWM2', 'PulseWidthByte', 255, 'PulseOffByte', 0,...
                     'Loop', 1, 'SendGlobalTimerEvents', 1, 'LoopInterval', 0.5); 
sma = AddState(sma, 'Name', 'TimerTrig', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'WaitForPoke'},...
    'OutputActions', {'GlobalTimerTrig', 1});
sma = AddState(sma, 'Name', 'WaitForPoke', ...
    'Timer', 0,...
    'StateChangeConditions', {'Port1In', 'StopGlobalTimer', 'Port2In', '>exit'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'StopGlobalTimer', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'WaitForPoke'},...
    'OutputActions', {'GlobalTimerCancel', 1});

