function data = fxFileReadLicor(path)

data = readtable(path);
data.Date.Format = 'yyyy-MM-dd HH:mm:ss';
data.Date = data.Date +data.Time;
data = table2timetable(data);
data = retime(data,'secondly','mean');
data = retime(data,'secondly','linear');
end

