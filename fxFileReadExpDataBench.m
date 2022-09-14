function [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataBench(dirPath, systemName)

path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+"Press"+Constants.FILE_TYPE;
if isfile(path)
    P = readFile(path, [12 5], systemName);
    P = myReTime(P);
else
    P = timetable(datetime('1984-07-21 12:00:00.000000'));
    P.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    P.Properties.DimensionNames{1} = 'Date';
end

path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+"Temp"+Constants.FILE_TYPE;
if isfile(path)
    auxT = readFile(path, [16 8:10], {'Temp_C_1' 'Temp_C_2' 'Temp_C_3'});
    temp = (auxT.Temp_C_1 + auxT.Temp_C_2 + auxT.Temp_C_3)/3.0;
    % Using col name as 'Chamber' instead of _20, so the plotting can understand this as the experimental temperature!
    T = timetable(auxT.Date, temp, 'VariableNames',systemName);
    T.Properties.DimensionNames{1} = 'Date';
    T.(systemName) = T.(systemName) - 273.15;
    T = myReTime(T);
else
    T = timetable(datetime('1984-07-21 12:00:00.000000'));
    T.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    T.Properties.DimensionNames{1} = 'Date';
end

path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+"RH"+Constants.FILE_TYPE;
if isfile(path)
    auxU = readFile(path, [15 7:14], {'RH_IN' 'RH_%_1' 'RH_%_2' 'RH_%_3' 'Temp_IN' 'T_RH_1' 'T_RH_2' 'T_RH_3'});
    auxU.('Temp_IN') = auxU.('Temp_IN') - 273.15;

    % Using col name as 'Chamber' instead of _20, so the plotting can understand this as the experimental RH!
    rh = (auxU.("RH_%_1") + auxU.("RH_%_2") + auxU.("RH_%_3"))/3.0;
    U = timetable(auxU.Date, rh, 'VariableNames',systemName);
    U_IN = timetable(auxU.Date, auxU.("RH_IN"), 'VariableNames',systemName);
    T_IN = timetable(auxU.Date, auxU.("Temp_IN"), 'VariableNames',systemName);
    U.Properties.DimensionNames{1} = 'Date';
    U_IN.Properties.DimensionNames{1} = 'Date';
    T_IN.Properties.DimensionNames{1} = 'Date';
    U = myReTime(U);
    U_IN = myReTime(U_IN);
    T_IN = myReTime(T_IN);
else
    U = timetable(datetime('1984-07-21 12:00:00.000000'));
    U.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    U.Properties.DimensionNames{1} = 'Date';
    U_IN = timetable(datetime('1984-07-21 12:00:00.000000'));
    U_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    U_IN.Properties.DimensionNames{1} = 'Date';
    T_IN = timetable(datetime('1984-07-21 12:00:00.000000'));
    T_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    T_IN.Properties.DimensionNames{1} = 'Date';
end

path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+"CO2"+Constants.FILE_TYPE;
if isfile(path)
    C = readFile(path, [7 3 5],{convertStringsToChars(systemName+"_CO2_1") convertStringsToChars(systemName+"_CO2_2")});

    [CO2_1, CO2_2] = fxDataCleanCO2(table2array(C(:,1)), table2array(C(:,2)));
    C.(systemName+"_CO2_1") = CO2_1;
    C.(systemName+"_CO2_2") = CO2_2;
    C = myReTime(C);
else
    C = timetable(datetime('1984-07-21 12:00:00.000000'));
    C.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    C.Properties.DimensionNames{1} = 'Date';
end

end

function data = readFile(path, colIndexes, colNames)
raw = readtable(path);
raw.Date = datetime(raw.timestamp, 'ConvertFrom','posixtime');
raw.Date.Format = 'yyyy-MM-dd HH:mm:ss.SSSSSSS';
data = table2timetable(raw(:,colIndexes));
data.Properties.VariableNames = colNames;
end

function TTout = myReTime(TTin)
TTout = retime(TTin,'secondly','mean');
TTout = retime(TTout,'secondly','linear');
end

