Installing Lab Streaming Layer on Windows PC with Matlab:
1. First, try from here: https://github.com/labstreaminglayer/liblsl-Matlab/releases
Take the "Latest release" which is applicable to your machine.
2. Download LabRecorder from here: https://github.com/labstreaminglayer/App-LabRecorder


If LSL doesn't work, try these next steps:
1. download labstreaminglayer-master.zip - extract into C:\toolboxes\
2. download liblsl-Matlab-master.zip     - extract into C:\toolboxes\LSL\liblsl-Matlab
3. download liblsl-1.13.1-Win64 (or other version)to C:\toolboxes\LSL\liblsl-Matlab\liblsl-matlab-master\
4. install MinGW-w64 Compiler for Matlab (can be done through Matlab: Home tab-Environment-Add-Ons...)
(link - https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler)
5. before running "build_mex" script, you may need to change the liblsl64.dll file to liblsl64.lib (this somewhat works on some systems).
6. run "build_mex" from C:\Toolboxes\labstreaminglayer-master\LSL\liblsl-Matlab\liblsl-Matlab-master
