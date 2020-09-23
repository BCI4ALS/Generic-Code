function SSVEP1_Online_EEG_Client_Scaffolding(recordingFolder)
%% SSVEP Online Scaffolding
% This code creates an online EEG buffer which utilizes the model trained
% offline, and corresponding frequencies, to classify between the possible targets.
% Assuming: 
% 1. EEG is recorded using openBCI and streamed through LSL.
% 2. SSVEP stimulation is handled on another machine (arduino/comp) using training frequencies.
% 3. A different machine is reading this LSL oulet stream for the commands sent through this code

% Remaining to be done by YOU:
% 1. Add a "voting machine" which takes the classification and counts how
% many consecutive answers in the same direction / target to get a high(er)
% accuracy rate, even though it slows down the process by a large factor.
% 2. Add the online preprocessing needed before using the data for
% classification
% 3. Add further, more elaborate, features.

% This code is part of the BCI-4-ALS Course written by Asaf Harel
% (harelasa@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.

%% This needs to change according to your system:
addpath('C:\Dropbox (BGU)\BCI resources\SSVEP\Generic Code\Online Code');
addpath('C:\Dropbox (BGU)\BCI resources\SSVEP\Generic Code\Offline Training');
addpath('C:\Toolboxes\labstreaminglayer-master\LSL\liblsl-Matlab\liblsl-Matlab');
addpath('C:\Toolboxes\labstreaminglayer-master\LSL\liblsl-Matlab\liblsl-Matlab\bin');

%% Set params
Fs = 125;                                           % openBCI sample rate
bufferLength = 1;                                   % how much data (in seconds) to buffer for each classification
% numVotes = 3;                                       % how many consecutive votes before classification?
output_rate = 1;                                    % desired output decision rate, in Hz
load(strcat(recordingFolder,'weightVec.mat'));      % load model weights from offline section 5
load(strcat(recordingFolder,'features.mat'));       % load features used in training
load(strcat(recordingFolder,'conditionFreq.mat'));  % load features used in training
numTargets = length(conditionFreq);                 % set number of possible targets 

%% Lab Streaming Layer Init
disp('Loading the Lab Streaming Layer library...');
lib = lsl_loadlib();
% Initialize the command outlet marker stream
disp('Opening Output Stream...');
info = lsl_streaminfo(lib,'MarkerStream','Markers',1,0,'cf_string','myuniquesourceid23443');
command_Outlet = lsl_outlet(info);

% Initialize the EEG inlet stream (from openBCI GUI on different system)
disp('Resolving an EEG Stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); 
end
disp('Success resolving!');
EEG_Inlet = lsl_inlet(result{1});

% Initialize some more variables:
samples = 0;
myBuffer = [];
iteration = 0;

pause(0.2);                                         % give the system some time to buffer data
myChunk = EEG_Inlet.pull_chunk();                   % get a chunk from the EEG LSL stream to get the buffer going

%% This is the main online script

while true
    iteration = iteration+1;                        % count iterations
    myChunk = EEG_Inlet.pull_chunk();               % get data from the inlet
    if ~empty(myChunk)
        myBuffer = [myBuffer myChunk];              % append new data to the current buffer
    else
        disp(strcat('Houston, we have a problem. Iteration:',numstr(iteration)));
    end
        
    samples = samples + 1/Fs;                       % perhaps utlize the inner system clock to properly time the input chunks and output estimate?
    
    % Check if buffer size exceeds the buffer length 
    % Consider adding to 'if' statement below: || (samples > (1 / output_rate))
    if (size(myBuffer,2)>(bufferLength*Fs))
        block = [myBuffer];
        
        % Extract features from the buffered block:
        EEG_Features = ExtractPowerBands(block,features,Fs);
        
        % Predict using previously learned model
        for targ = 1:numTargets
            % First element in weightVec is the intercept [ Y = wX + w(1) ]
            myPredictions(targ) = weightVec(targ,2:end)*EEG_Features'+weightVec(1); 
        end
        [M,myEstimate] = max(myPredictions);
        disp(strcat('The estimated target is:', num2str(myEstimate)));
        disp(strcat('The target prediction vector is:', num2str(myPredictions)));
       
        % Send estimate to voting machine (apply different approaches)
        % sendVote(myEstimate);
        
        % Send command through LSL:
        command_Outlet.push_sample(myEstimate);
        
        % clear buffer
        myBuffer = [];
        myPredictions = [];
        % clear timer
        samples = samples - 1/output_rate;
    end
end