function [CO2_1, CO2_2] = fxDataCleanCO2(CO2_1,CO2_2)
%Cleans sensor data (removing missing, "0", samples).

rows = size(CO2_1);
for i = 1:rows
    if CO2_1(i) == 0
        CO2_1 = interp(CO2_1, i, rows);
    end
    if CO2_2(i) == 0
        CO2_2 = interp(CO2_2, i, rows);
    end
end
end

%
% This code has been verified with data from all 4 mesonet experiments,
% with data from LACAS versions 2.5, 2.0, and open sensors. 
%
function result = interp(data, currentIndex, dataSize)
for j=currentIndex+1:dataSize
    if data(j) ~=0
        break;
    end
end
x=currentIndex-1:j;
y=data(x);
xi=x(find(y~=0));
yi=y(find(y~=0));
res=interp1(xi,yi,x,'linear');
data(x) = res;
result = data;
end