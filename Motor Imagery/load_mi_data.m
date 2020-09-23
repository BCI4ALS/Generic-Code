% Loads clean segmented Motor Imagery data and returns it in MIeeg struct
% Replace this function with your data loader, but use MIeeg struct fields
%
% inputs:
%   miDataFname - file path and file name
% outputs:
%   MIeeg.data - time series (trials x samples x channels)
%   MIeeg.labels - categorical labels (start from 1)
%   MIeeg.labelsText
%   MIeeg.fs - sampling frequency [Hz]
%   MIeeg.elecNames - electrode names
%   MIeeg.imaginPeriodSec - trial time period of pure motor imagery
%   MIeeg.units
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function MIeeg = load_mi_data(miDataFname)

load(miDataFname);
MIeeg.data = P_C_S.data(:,:,1:2);%last channel is trigger 
MIeeg.labels = P_C_S.attribute(strcmp(P_C_S.attributename,'LEFT'),:)+1;
MIeeg.labelsText = {'Left','Right'};
art_rem = logical(P_C_S.attribute(strcmp(P_C_S.attributename,'ARTIFACT'),:)) |...
    logical(P_C_S.attribute(strcmp(P_C_S.attributename,'REMOVE'),:));
MIeeg.data(art_rem,:,:) = [];
MIeeg.labels(art_rem) = [];
MIeeg.fs = P_C_S.samplingfrequency;
MIeeg.elecNames = {'C3','C4'}; %keep electrode names order according to the data
MIeeg.imaginPeriodSec = [2,6]; %imagination begins at second 2 and ends at second 6. preparation to MI is from 0 to 2 sec
MIeeg.units = 'uV';
