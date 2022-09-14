function [P, T, U, C, T_IN, U_IN] = fxFileRead(expType, dirPath, systemName)
if expType == Constants.BENCH
    [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataBench(dirPath, systemName);
else
    [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataMesonet(dirPath, systemName);
end
end

