function data = fxFileReadChamber(path)

opts = detectImportOptions(path);
opts = setvaropts(opts,'Date','InputFormat','MM/dd/uuuu HH:mm:ss');
data = readtable(path, opts);
data.Date.Format = 'yyyy-MM-dd HH:mm:ss';
data = table2timetable(data);
data = retime(data,'minutely','mean');
data = retime(data,'minutely','linear');
data.Temp = data.External_Temperature_C;
end

