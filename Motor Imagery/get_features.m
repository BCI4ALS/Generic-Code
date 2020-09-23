% Extracts custom made features from the data.
% The features adapted to specific motor imagery data and paradigm
% Remove / comment out features you don't use
% Replace these features with features that reflect your data and your findings
%
% inputs:
%   MIeeg
% outputs:
%   features - feature values matrix: trial x feature
%   featureNames
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function [features, featureNames] = get_features(MIeeg)

features = [];
featureNames = [];

c3Inx = strcmp(MIeeg.elecNames,'C3');
c4Inx = strcmp(MIeeg.elecNames,'C4');

sampleRange = 1:size(MIeeg.data,2);
imaginPeriodSmp = sampleRange(sampleRange>=MIeeg.imaginPeriodSec(1)*MIeeg.fs & ...
    sampleRange<=MIeeg.imaginPeriodSec(2)*MIeeg.fs);
extendedImaginPeriodSmp = sampleRange(sampleRange>=1.5*MIeeg.fs & ... %in case starting imagining during the preparation time
    sampleRange<=MIeeg.imaginPeriodSec(2)*MIeeg.fs); %used for normalization

[c3Pxx, f] = pwelch(MIeeg.data(:,imaginPeriodSmp,c3Inx)',round(1.5*MIeeg.fs),[],[],MIeeg.fs);
[c4Pxx, f] = pwelch(MIeeg.data(:,imaginPeriodSmp,c4Inx)',round(1.5*MIeeg.fs),[],[],MIeeg.fs);

c3FullRangePower = bandpower(MIeeg.data(:,extendedImaginPeriodSmp,c3Inx)');
c4FullRangePower = bandpower(MIeeg.data(:,extendedImaginPeriodSmp,c4Inx)');


%Features based on time series differences
featureNames = [featureNames {'C3std'}];
features = [features std(MIeeg.data(:,imaginPeriodSmp,c3Inx),[],2)];
featureNames = [featureNames {'C4std'}];
features = [features std(MIeeg.data(:,imaginPeriodSmp,c4Inx),[],2)];

%Features based on spectral differences
featureNames = [featureNames {'C3bndpwr1'}];
features = [features bandpower(c3Pxx,f,[15 19],'psd')'];
featureNames = [featureNames {'C3bndpwr2'}];
features = [features bandpower(c3Pxx,f,[8.5 11],'psd')'];
featureNames = [featureNames {'C4bndpwr1'}];
features = [features bandpower(c4Pxx,f,[15 19],'psd')'];
featureNames = [featureNames {'C4bndpwr2'}];
features = [features bandpower(c4Pxx,f,[8.5 10],'psd')'];
featureNames = [featureNames {'C4bndpwr3'}];
features = [features bandpower(c4Pxx,f,[4.5 6.5],'psd')'];

%Features based on relative power of spectral differences [dB]
featureNames = [featureNames {'C3bndpwrDB1'}];
periodSmp = sampleRange(sampleRange>=4*MIeeg.fs & sampleRange<=5.8*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[14.5 19])./c3FullRangePower)'];
featureNames = [featureNames {'C3bndpwrDB2'}];
periodSmp = sampleRange(sampleRange>=3.7*MIeeg.fs & sampleRange<=5.8*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[7 12.5])./c3FullRangePower)'];
featureNames = [featureNames {'C3bndpwrDB3'}];
periodSmp = sampleRange(sampleRange>=1.7*MIeeg.fs & sampleRange<=2.5*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[49 63])./c3FullRangePower)'];
featureNames = [featureNames {'C4bndpwrDB1'}];
periodSmp = sampleRange(sampleRange>=3.7*MIeeg.fs & sampleRange<=5.8*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[13 19.5])./c4FullRangePower)'];
featureNames = [featureNames {'C4bndpwrDB2'}];
periodSmp = sampleRange(sampleRange>=4*MIeeg.fs & sampleRange<=5.8*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[29.5 36.5])./c4FullRangePower)'];
featureNames = [featureNames {'C4bndpwrDB3'}];
periodSmp = sampleRange(sampleRange>=1.7*MIeeg.fs & sampleRange<=3.3*MIeeg.fs);
features = [features 10*log10(bandpower(MIeeg.data(:,periodSmp,c3Inx)',MIeeg.fs,[7.5 11.5])./c4FullRangePower)'];

%Features based on spectral entropy
featureNames = [featureNames {'C3spectralEntropy'}];
c3PxxPdf = c3Pxx./repmat(sum(c3Pxx,1),size(c3Pxx,1),1);
features = [features sum(-c3PxxPdf.*log2(c3PxxPdf),1)'];
featureNames = [featureNames {'C4spectralEntropy'}];
c4PxxPdf = c4Pxx./repmat(sum(c4Pxx,1),size(c4Pxx,1),1);
features = [features sum(-c4PxxPdf.*log2(c4PxxPdf),1)'];
