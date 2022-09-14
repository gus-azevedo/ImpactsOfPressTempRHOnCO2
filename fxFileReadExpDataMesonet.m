function [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataMesonet(dirPath, systemName)

path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+Constants.FILE_TYPE;
if isfile(path)
    rawGS = readtable(path);
    rawGS = renamevars(rawGS, 'Date', 'Date');
    rawGS.Date = datetime(rawGS.Date, 'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSSS''Z');
    rawGS.Date.Format = 'yyyy-MM-dd HH:mm:ss.SSSSSSS';
    data = table2timetable(rawGS(1:end,[2 6 19:23 24:27 35]));
    data.Properties.VariableNames = {'Pressure_Pa' 'Temp_C_1' 'Temp_C_2' 'Temp_C_3' 'CO2_ppm_1' 'CO2_ppm_2' 'RH_IN' 'RH_%_1' 'RH_%_2' 'RH_%_3' 'Temp_IN'};

    %% Clean sensor data (removing missing, "0", samples).
    [CO2_1, CO2_2] = fxDataCleanCO2(table2array(data(:,5)), table2array(data(:,6)));
    data.CO2_ppm_1 = CO2_1;
    data.CO2_ppm_2 = CO2_2;

    data = retime(data,'secondly','mean');
    data = retime(data,'secondly','linear');

    data2 = data(:,1);
    data2.Temp = (data.Temp_C_1 + data.Temp_C_2 + data.Temp_C_3)/3.0;
    data2.Temp = data2.Temp - 273.15;
    data2.RH = (data.("RH_%_1") + data.("RH_%_2") + data.("RH_%_3"))/3.0;
    data2.CO2_ppm_1 = data.CO2_ppm_1;
    data2.CO2_ppm_2 = data.CO2_ppm_2;
    data2.RH_IN = data.RH_IN;
    data2.Temp_IN = data.Temp_IN - 273.15;
    data = data2;


    P = timetable(data.Date, data.Pressure_Pa, 'VariableNames', ...
        {convertStringsToChars(systemName)});
    T = timetable(data.Date, data.Temp, 'VariableNames', ...
        {convertStringsToChars(systemName)});
    U = timetable(data.Date, data.RH, 'VariableNames', ...
        {convertStringsToChars(systemName)});
    T_IN = timetable(data.Date, data.Temp_IN, 'VariableNames', ...
        {convertStringsToChars(systemName)});
    U_IN = timetable(data.Date, data.RH_IN, 'VariableNames', ...
        {convertStringsToChars(systemName)});

    C = timetable(data.Date, data.CO2_ppm_1, data.CO2_ppm_2, 'VariableNames', {convertStringsToChars(systemName+"_CO2_1") convertStringsToChars(systemName+"_CO2_2")});
else
    P = timetable(datetime('1984-07-21 12:00:00.000000'));
    P.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    P.Properties.DimensionNames{1} = 'Date';
    T = timetable(datetime('1984-07-21 12:00:00.000000'));
    T.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    T.Properties.DimensionNames{1} = 'Date';
    U = timetable(datetime('1984-07-21 12:00:00.000000'));
    U.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    U.Properties.DimensionNames{1} = 'Date';
    U_IN = timetable(datetime('1984-07-21 12:00:00.000000'));
    U_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    U_IN.Properties.DimensionNames{1} = 'Date';
    T_IN = timetable(datetime('1984-07-21 12:00:00.000000'));
    T_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    T_IN.Properties.DimensionNames{1} = 'Date';
    C = timetable(datetime('1984-07-21 12:00:00.000000'));
    C.Time.Format = 'yyyy-MM-dd HH:mm:ss';
    C.Properties.DimensionNames{1} = 'Date';
end

end