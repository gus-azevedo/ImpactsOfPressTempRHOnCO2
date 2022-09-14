function [P, T, U, C, T_IN, U_IN, PPT] = fxFileLoad(expType, dirPath)

sensorsRef = [Constants.REF_IN, "ReferenceLab"];
sensorsTest = ["TestSystem1", "TestSystem2", "TestSystem3"];
chamber = "Chamber";

P = timetable(datetime('1984-07-21 12:00:00.000000'));
P.Time.Format = 'yyyy-MM-dd HH:mm:ss';
P.Properties.DimensionNames{1} = 'Date';

T = timetable([datetime('1984-07-21 12:00:00.000000')]);
T.Time.Format = 'yyyy-MM-dd HH:mm:ss';
T.Properties.DimensionNames{1} = 'Date';

U = timetable([datetime('1984-07-21 12:00:00.000000')]);
U.Time.Format = 'yyyy-MM-dd HH:mm:ss';
U.Properties.DimensionNames{1} = 'Date';

C = timetable([datetime('1984-07-21 12:00:00.000000')]);
C.Time.Format = 'yyyy-MM-dd HH:mm:ss';
C.Properties.DimensionNames{1} = 'Date';

T_IN = timetable([datetime('1984-07-21 12:00:00.000000')]);
T_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
T_IN.Properties.DimensionNames{1} = 'Date';

U_IN = timetable([datetime('1984-07-21 12:00:00.000000')]);
U_IN.Time.Format = 'yyyy-MM-dd HH:mm:ss';
U_IN.Properties.DimensionNames{1} = 'Date';

PPT = timetable([datetime('1984-07-21 12:00:00.000000')]);
PPT.Time.Format = 'yyyy-MM-dd HH:mm:ss';
PPT.Properties.DimensionNames{1} = 'Date';


for i=1:size(sensorsRef, 2)
    systemName = sensorsRef(i);
    path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+Constants.FILE_TYPE;
    if isfile(path)
        data = fxFileReadLicor(path);

        auxP = timetable(data.Date, data.Pressure_Pa, 'VariableNames', ...
            {convertStringsToChars(systemName)});
        P = synchronize(P, auxP, 'union', 'linear');

        auxT = timetable(data.Date, data.Temperature_C, 'VariableNames', ...
            {convertStringsToChars(systemName)});
        T = synchronize(T, auxT, 'union', 'linear');

        auxCO2 = timetable(data.Date, data.CO2_ppm, 'VariableNames', ...
            {convertStringsToChars(systemName)});
        C = synchronize(C, auxCO2, 'union', 'linear');

        if systemName == Constants.REF_IN
            auxPPT = timetable(data.Date, data.H2O_ppt, 'VariableNames', ...
                {convertStringsToChars(systemName)});
            PPT = synchronize(PPT, auxPPT, 'union', 'linear');
        end
    end
end

for i=1:size(sensorsTest, 2)
    systemName = sensorsTest(i);
    %path = dirPath+Constants.SYSTEM_SEPARATOR+systemName+Constants.FILE_TYPE;
    %if isfile(path)
        [auxP, auxT, auxU, auxC, auxTin, auxUin] = fxFileRead(expType, dirPath, systemName);
        P = synchronize(P, auxP, 'union', 'linear');
        if (~isempty(auxT) && mean(auxT.(systemName))>0)
            T = synchronize(T, auxT, 'union', 'linear');
        end
        if (~isempty(auxU) && mean(auxU.(systemName))>0)
            U = synchronize(U, auxU, 'union', 'linear');
        end
        C = synchronize(C, auxC, 'union', 'linear');
        if (~isempty(auxTin) && mean(auxTin.(systemName))>0)
            T_IN = synchronize(T_IN, auxTin, 'union', 'linear');
        end
        if (~isempty(auxUin) && mean(auxUin.(systemName))>0)
            U_IN = synchronize(U_IN, auxUin, 'union', 'linear');
        end
    %end
end

path = dirPath+Constants.SYSTEM_SEPARATOR+chamber+Constants.FILE_TYPE;
if isfile(path)
    data = fxFileReadChamber(path);
    auxT = timetable(data.Date, data.Temp, 'VariableNames', chamber);
    T = synchronize(T, auxT, 'union', 'linear');

    if contains('RH',data.Properties.VariableNames)
        auxU = timetable(data.Date, data.RH, 'VariableNames', chamber);
        U = synchronize(U, auxU, 'union', 'linear');
    end
    if contains('Pressure_Pa',data.Properties.VariableNames)
        auxP = timetable(data.Date, data.Pressure_Pa, 'VariableNames', chamber);
        P = synchronize(P, auxP, 'union', 'linear');
    end
end


if (size(P,1) == 1)
    P = [];
else
    P = P(2:end,:);
end

if (size(T,1) == 1)
    T = [];
else
    T = T(2:end,:);
end

if (size(U,1) == 1)
    U = [];
else
    U = U(2:end,:);
end

if (size(C,1) == 1)
    C = [];
else
    C = C(2:end,:);
end

if (size(T_IN,1) == 1)
    T_IN = [];
else
    T_IN = T_IN(2:end,:);
end

if (size(U_IN,1) == 1)
    U_IN = [];
else
    U_IN = U_IN(2:end,:);
end

if (size(PPT,1) == 1)
    PPT = [];
else
    PPT = PPT(2:end,:);
end

end

