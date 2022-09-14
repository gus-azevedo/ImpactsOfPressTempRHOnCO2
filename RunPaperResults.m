%% Start up
clear; close all; clc;
format longG;
addpath('../');

figureIndex = 1;

% runTimeConfig = Config.RUN_1_PRE;
% experimentDates = Dates.RUN_1_PRE;
% runTimeConfig = Config.RUN_2;
% experimentDates = Dates.RUN_2_IPOST;
% runTimeConfig = Config.RUN_2_POST;
% experimentDates = Dates.RUN_2_POST;

% runTimeConfig = Config.RUN_1_PRESS;
% experimentDates = Dates.RUN_1_PRESS;
% runTimeConfig = Config.RUN_1;
% experimentDates = Dates.RUN_1_TEMP;
% experimentDates = Dates.RUN_1_RH;
% experimentDates = Dates.RUN_1_TEMP_RH;
% runTimeConfig = Config.RUN_2;
% experimentDates = Dates.RUN_2_TEMP;
% experimentDates = Dates.RUN_2_RH;
% experimentDates = Dates.RUN_2_RH_Fix;
% experimentDates = Dates.RUN_2_TEMP_RH;

% % runTimeConfig = Config.RUN_S2;
% experimentDates = Dates.RUN_2_TEMP_RH;

% runTimeConfig = Config.BENCH_RH_RUN_3;
% experimentDates = Dates.BENCH_RH_RUN_3;
% runTimeConfig = Config.BENCH_T_RUN_4;
% experimentDates = Dates.BENCH_T_RUN_4;
% runTimeConfig = Config.BENCH_T_RUN_5;
% experimentDates = Dates.BENCH_T_RUN_5;
% runTimeConfig = Config.BENCH_T_RUN_6;
% experimentDates = Dates.BENCH_T_RUN_6;
% runTimeConfig = Config.BENCH_T_RUN_7;
% experimentDates = Dates.BENCH_T_RUN_7;
% runTimeConfig = Config.BENCH_RH_RUN_8;
% experimentDates = Dates.BENCH_RH_RUN_8;
% runTimeConfig = Config.BENCH_RH_RUN_9;
% experimentDates = Dates.BENCH_RH_RUN_9;

[P, T, U, C, T_IN, U_IN, PPT] = fxFileLoad(runTimeConfig);

% expType = Constants.PRES;
expType = Constants.TEMP;
% expType = Constants.RH;
% expType = Constants.T_RH;

% [figureIndex, referenceOffSet] = fxPlotSensorComparison(runTimeConfig, experimentDates, figureIndex);
figureIndex = runExperiment(runTimeConfig, experimentDates, expType, P, T, U, C, T_IN, U_IN, PPT, figureIndex);
% runScatters(runTimeConfig, experimentDates, expType, P, T, U, C, T_IN, U_IN, PPT, figureIndex);




%% Shutting down
rmpath('../');

function figureIndex = runScatters(runTimeConfig, experimentDates, expType, P, T, U, C, T_IN, U_IN, PPT, figureIndex)
[auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT] = fxDataSelect(experimentDates, P, T, U, C, T_IN, U_IN, PPT);
% Offset, filters, number of samples
if contains('_820',auxC.Properties.VariableNames)
    % if(runTimeConfig.expLocation == Constants.MESONET)
    auxC.('_820') = auxC.('_820') + Constants.OFFSET_820;
end
auxC = fxDataRemoveNoiseCO2(runTimeConfig, auxC);
[auxP, auxT, auxU, auxC, auxTin, auxUin] = fxDataRetimeData2Minute(runTimeConfig, auxP, auxT, auxU, auxC, auxTin, auxUin);
% [auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT] = testNAN(experimentDates, auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT);
if(expType == Constants.PRES)
    sizeTestSensors  = size(runTimeConfig.sensorsTest,2);
    j=0;
    %     for i=1:sizeTestSensors
    %         dataId = runTimeConfig.sensorsTest(i)+runTimeConfig.idTestSensors(i+j);
    var.Date = auxP.Date;
    var.val1 = auxP.('_Chamber');
    var.val2 = auxP.('_Chamber');
    varRef = Constants.REF_PRES;
    %     end
end

if(expType == Constants.TEMP)
    var.Date = auxTin.Date;
    var.val1 = auxTin.('_20');
    var.val2 = auxTin.('_20');
    varRef = Constants.REF_TEMP;
    
end

if(expType == Constants.RH)
    %         var.Date = auxU.Date;
    %         var.val1 = auxU.('_Chamber');
    %         var.val2 = auxU.('_Chamber');
    var.Date = auxUin.Date;
    var.val1 = auxUin.('_25');
    var.val2 = auxUin.('_25');
    varRef = Constants.REF_RH;
    
end

fxPlotScatter(runTimeConfig, var, varRef, auxC, figureIndex, "A");
figureIndex = figureIndex +1;
end


function figureIndex = runExperiment(runTimeConfig, experimentDates, expType, P, T, U, C, T_IN, U_IN, PPT, figureIndex)
%% Calls all subroutines to produces experiment results

% Limit data to experiment time frame.
[auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT] = fxDataSelect(experimentDates, P, T, U, C, T_IN, U_IN, PPT);
% Offset, filters, number of samples
if contains('_820',auxC.Properties.VariableNames)
    % if(runTimeConfig.expLocation == Constants.MESONET)
    auxC.('_820') = auxC.('_820') + Constants.OFFSET_820;
end
auxC = fxDataRemoveNoiseCO2(runTimeConfig, auxC);
[auxP, auxT, auxU, auxC, auxTin, auxUin] = fxDataRetimeData2Minute(runTimeConfig, auxP, auxT, auxU, auxC, auxTin, auxUin);
% Plot experimental conditions.
titleString = fxMakeTittle(runTimeConfig,expType,Constants.MODE_EXPERIMENT);
% [auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT] = testNAN(experimentDates, auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT);
figureIndex = fxPlotExperimentalConditions(auxP, auxT, auxU, auxTin, auxUin, auxPPT, figureIndex, experimentDates, GUIUtils.COND_TITLE+titleString);
figureIndex = showExperimentResults(runTimeConfig, expType, auxP, auxT, auxU, auxC, figureIndex, experimentDates, titleString);
% auxTin.('_00') = auxT.('_Chamber');
% auxUin.('_00') = auxU.('_Chamber');
% correctCO2 = fxDataApplyCorrection (runTimeConfig, Constants.PRES, auxP, auxT, auxU, auxC);
correctCO2 = fxDataApplyCorrection (runTimeConfig, expType, auxP, auxTin, auxUin, auxC);
figureIndex = showExperimentResults(runTimeConfig, expType, auxP, auxT, auxU, correctCO2, figureIndex, experimentDates, titleString+" (Corrected)");
% showStack(runTimeConfig, auxP, auxT, auxU, correctCO2, auxC, auxTin, auxUin, figureIndex, experimentDates, titleString+" (Corrected)");
end


function figureIndex = showExperimentResults(runTimeConfig, expType, P, T, U, C, figureIndex, experimentDates, titleString)
%% Evaluates errror  and plots.
C = fxDataOffset2Reference(runTimeConfig, C);
calculateRMSE(runTimeConfig, C);
if(expType == Constants.TEMP) || (expType == Constants.T_RH)
    auxV = T;
    auxVString = GUIUtils.VAR_TEMP+" "+GUIUtils.UNIT_CELSIUS;
    auxVLim = GUIUtils.LIMIT_TEMP;
else
    if (expType == Constants.RH)
        auxV = U;
        auxVString = GUIUtils.VAR_RH+" "+GUIUtils.UNIT_RH;
        auxVLim = GUIUtils.LIMIT_RH;
    else
        if (expType == Constants.PRES)
            auxV = P;
            auxVString = GUIUtils.VAR_PRES+" "+GUIUtils.UNIT_PA;
            auxVLim = GUIUtils.LIMIT_PRES;
        end
    end
end
% if(runTimeConfig.expLocation == Constants.BENCH)
%     auxV.Date = T.Date;
%     auxV.("_Chamber") = T.("_20");
%     auxVLim = GUIUtils.LIMIT_TEMP;
% end

figureIndex = fxPlotExperimentalResults(auxV, auxVString, auxVLim, C, figureIndex, experimentDates, titleString);
% figureIndex = fxPlotCorrelations(runTimeConfig, P, T, U, C, figureIndex, titleString);
end


function calculateRMSE(runTimeConfig, CO2)
%% Evaluates sensor error to reference sensor;
j=0;
sizeTestSensors = size(runTimeConfig.sensorsTest,2);
for i=1:sizeTestSensors
    RMSE(runTimeConfig, i, j, CO2);
    j = j+ 1;
    RMSE(runTimeConfig, i, j, CO2);
end
end

function RMSE(runTimeConfig, i, j, CO2)
%% Actual RMSE math and printing.
dataId = runTimeConfig.sensorsTest(i)+runTimeConfig.idTestSensors(i+j);
diffC = CO2.(dataId) - CO2.('_840');
RMSE = sqrt(mean((diffC).^2));
maxE = max(abs(diffC));
disp("RMSE "+dataId+" & "+round(RMSE,2)+"\\");
% disp("Max "+dataId+" & "+round(maxE,2)+"\\");
end

function [auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT] = testNAN(experimentDates, auxP, auxT, auxU, auxC, auxTin, auxUin, auxPPT)
auxP(timerange(datetime("2022-05-18 08:52:00"), datetime(experimentDates.dateEnd), 'closed'),'_20') = {NaN};
auxTin(timerange(datetime("2022-05-18 08:52:00"), datetime(experimentDates.dateEnd), 'closed'),'_20') = {NaN};
if ~isempty(auxUin)
    auxUin(timerange(datetime("2022-05-18 08:52:00"), datetime(experimentDates.dateEnd), 'closed'),'_20') = {NaN};
end
auxC(timerange(datetime("2022-05-18 08:52:00"), datetime(experimentDates.dateEnd), 'closed'),'_20_1') = {NaN};
auxC(timerange(datetime("2022-05-18 08:52:00"), datetime(experimentDates.dateEnd), 'closed'),'_20_2') = {NaN};
end

function figureIndex = showStack(runTimeConfig, P, T, U, corrected, C, Tin, Uin, figureIndex, experimentDates, titleString)
%% 

startDate = datetime(experimentDates.dateStart);
endDate = datetime(experimentDates.dateEnd);

sizeC = size(C,2);
plots = gobjects(1,sizeC+1);
lgdStrings = cell(1,sizeC+1);
plotIndex =2;

C = fxDataOffset2Reference(runTimeConfig, C);
corrected = fxDataOffset2Reference(runTimeConfig, corrected);
f = figure(figureIndex);
f.Units = 'normalized';
f.Position = [GUIUtils.FIGURE_LEFT GUIUtils.FIGURE_BOTTOM 1 1];
colororder({GUIUtils.COLOR_DEFAULT,GUIUtils.COLOR_DEFAULT});

t = tiledlayout(4,1,'TileSpacing','compact');
bgAx = axes(t,'XTick',[],'YTick',[],'Box','off');
bgAx.Layout.TileSpan = [4 1];
bgAx.LineWidth(1) = GUIUtils.AXIS_WIDTH;
bgAx.YAxis.Visible = 'off';

chambId = '_Chamber';

% Create first plot
ax1 = axes(t);
ax1.Layout.Tile = 1;
hold on;
aux = C;
for i=1:sizeC
   dataId = aux.Properties.VariableNames(i);
   if~(dataId == "_820")
       if~(dataId == "_840")
           plots(plotIndex) = plot(aux.Date, aux{:,i}, 'Marker', 'none', 'LineStyle',...
               "--", 'Color', GUIUtils.getLineColor(dataId),...
               'LineWidth', GUIUtils.getLineWidth(dataId));
           plotIndex = plotIndex +1;
           
           plots(plotIndex) = plot(corrected.Date, corrected{:,i}, 'LineStyle',...
               GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
               'LineWidth', GUIUtils.getLineWidth(dataId));
           plotIndex = plotIndex +1;
       else
           plots(plotIndex) = plot(aux.Date, aux{:,i}, 'Marker', 'none', 'LineStyle',...
               GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
               'LineWidth', GUIUtils.getLineWidth(dataId));
           plotIndex = plotIndex +1;
       end
    end
end
ax1.FontSize = GUIUtils.FONT_SIZE_TICK;
ax1.LineWidth(1) = GUIUtils.AXIS_WIDTH;
ax1.Box = 'off';
grid(ax1, 'on');
ax1.XAxis.Visible = 'off';
ylim(ax1,GUIUtils.LIMIT_CO2);
ylabel(ax1, GUIUtils.VAR_CO2_ABREV+" "+GUIUtils.UNIT_PPM,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
xlim(ax1, [startDate endDate]);
yyaxis(ax1, 'right');
r1=ax1.YAxis(1);
r2=ax1.YAxis(2);
linkprop([r1 r2],'Limits');


% Create second plot
ax2 = axes(t);
ax2.Layout.Tile = 2;
hold on;
aux = P;
for i=1:size(P,2)
   dataId = aux.Properties.VariableNames(i);
    plot(aux.Date, aux{:,i}, 'Marker', 'none', 'LineStyle',...
        GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
        'LineWidth', GUIUtils.getLineWidth(dataId));
end
% plot(ax2, P.Date, P.(dataId), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
%     'LineWidth', GUIUtils.getLineWidth(dataId));
% plot(ax2, P.Date, P.(RefId), 'LineStyle',...
%     GUIUtils.getLineStyle(RefId), 'Color', GUIUtils.getLineColor(RefId),...
%     'LineWidth', GUIUtils.getLineWidth(RefId));
ytickformat(ax2,'%.2g');
ax2.YAxis.Exponent = 0;
ax2.FontSize = GUIUtils.FONT_SIZE_TICK;
ax2.LineWidth(1) = GUIUtils.AXIS_WIDTH;
ax2.Box = 'off';
grid(ax2, 'on');
ax2.XAxis.Visible = 'off';
ylim(ax2, GUIUtils.LIMIT_PRES);
ylabel(ax2, GUIUtils.VAR_PRES_ABREV+" "+GUIUtils.UNIT_PA,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
xlim(ax2, [startDate endDate]);
yyaxis(ax2, 'right');
ylim(ax2,GUIUtils.LIMIT_PRES);
ytickformat(ax2,'%.2g');
ax2.YAxis(2).Exponent = 0;
% yticklabels({});

% Create third plot
ax3 = axes(t);
ax3.Layout.Tile = 3;
hold on;
plots(1) = plot(ax3, T.Date, T.('_Chamber'), 'LineStyle',...
    GUIUtils.getLineStyle(chambId), 'Color', GUIUtils.getLineColor(chambId),...
    'LineWidth', GUIUtils.getLineWidth(chambId));
lgdStrings(1) = {"Chamber"};
aux = Tin;
for i=1:size(Tin,2)
   dataId = aux.Properties.VariableNames(i);
    plot(aux.Date, aux{:,i}, 'Marker', 'none', 'LineStyle',...
        GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
        'LineWidth', GUIUtils.getLineWidth(dataId));
end
ax3.FontSize = GUIUtils.FONT_SIZE_TICK;
ax3.LineWidth(1) = GUIUtils.AXIS_WIDTH;
ax3.Box = 'off';
grid(ax3, 'on');
ax3.XAxis.Visible = 'off';
ylim(ax3, GUIUtils.LIMIT_TEMP);
ylabel(ax3, GUIUtils.VAR_TEMP_ABREV+" "+GUIUtils.UNIT_CELSIUS,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
xlim(ax3, [startDate endDate]);
yyaxis(ax3, 'right');
ylim(ax3,GUIUtils.LIMIT_TEMP);
% yticklabels({});


% Create forth plot
ax4 = axes(t);
ax4.Layout.Tile = 4;
hold on;
plot(ax4, U.Date, U.('_Chamber'), 'LineStyle',...
    GUIUtils.getLineStyle(chambId), 'Color', GUIUtils.getLineColor(chambId),...
    'LineWidth', GUIUtils.getLineWidth(chambId));
aux = Uin;
for i=1:size(Uin,2)
   dataId = aux.Properties.VariableNames(i);
    plot(aux.Date, aux{:,i}, 'Marker', 'none', 'LineStyle',...
        GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
        'LineWidth', GUIUtils.getLineWidth(dataId));
end
ax4.FontSize = GUIUtils.FONT_SIZE_TICK;
ax4.LineWidth(1) = GUIUtils.AXIS_WIDTH;
ax4.Box = 'off';
grid(ax4, 'on');
ax4.XAxis.Visible = 'on';
ylim(ax4, GUIUtils.LIMIT_RH);
ylabel(ax4, GUIUtils.VAR_RH_ABREV+" "+GUIUtils.UNIT_RH,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
xlim(ax4, [startDate endDate]);
xlabel(ax4, GUIUtils.VAR_TIME+" "+GUIUtils.UNIT_TIME, 'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
yyaxis(ax4, 'right');
ylim(ax4,GUIUtils.LIMIT_RH);
% yticklabels({});

% lgdStrings = {GUIUtils.getString(chambId), GUIUtils.getString(RefId), GUIUtils.getString(dataId1), GUIUtils.getString(dataId2)};
linkaxes([ax1 ax2 ax3 ax4], 'x');
title(t,titleString, 'FontSize', GUIUtils.FONT_SIZE_LARGER, 'FontName',GUIUtils.FONT_TIMESNR);
lgd = legend(plots,lgdStrings, 'Orientation', 'horizontal', 'Location','layout', 'FontSize', GUIUtils.FONT_SIZE_SMALL, 'FontName',GUIUtils.FONT_TIMESNR);
lgd.Layout.Tile = 'north';
set(gcf,'color','w');



figureIndex = figureIndex+1;

% %% 
% startDate = datetime(experimentDates.dateStart);
% endDate = datetime(experimentDates.dateEnd);
% 
% plots = gobjects(1,4);
% lgdStrings = strings(1,4);
% 
% C = fxDataOffset2Reference(runTimeConfig, C);
% corrected = fxDataOffset2Reference(runTimeConfig, corrected);
% f = figure(figureIndex);
% f.Units = 'normalized';
% f.Position = [GUIUtils.FIGURE_LEFT GUIUtils.FIGURE_BOTTOM 1 1];
% colororder({GUIUtils.COLOR_DEFAULT,GUIUtils.COLOR_DEFAULT});
% %     table = timetable(P.Date, C.('_20_1'));
% %     table.C2 =  C.('_20_2');
% %     table.Cor1 = corrected.('_20_1');
% %     table.Cor2 = corrected.('_20_2');
% %     table.Ref = C.('_840');
% %     table.P1 = P.('_20');
% %     table.P2 = P.('_20');
% %     table.PRef = P.('_840');
% %     table.T = Tin.('_20');
% %     table.T2 = T.('_Chamber');
% %     table.U = Uin.('_20');
% %     table.U2 = U.('_Chamber');
% %
% %     vars = {GUIUtils.VAR_CO2_ABREV+" "+GUIUtils.UNIT_PPM, GUIUtils.VAR_PRES_ABREV+" "+GUIUtils.UNIT_PA, GUIUtils.VAR_TEMP_ABREV+" "+GUIUtils.UNIT_CELSIUS, GUIUtils.VAR_RH_ABREV+" "+GUIUtils.UNIT_RH};
% %     s = stackedplot(table, {[1,2,3,4,5],[6,7,8], [9,10],[11,12]});
% %     s.
% 
% t = tiledlayout(4,1,'TileSpacing','compact');
% bgAx = axes(t,'XTick',[],'YTick',[],'Box','off');
% bgAx.Layout.TileSpan = [4 1];
% bgAx.LineWidth(1) = GUIUtils.AXIS_WIDTH;
% bgAx.YAxis.Visible = 'off';
% 
% dataId = '_20';
% dataId1 = '_20_1';
% dataId2 = '_20_2';
% RefId = '_840';
% chambId = '_Chamber';
% 
% % Create first plot
% ax1 = axes(t);
% ax1.Layout.Tile = 1;
% hold on;
% plots(2) = plot(ax1, C.Date, C.(RefId), 'LineStyle',...
%     GUIUtils.getLineStyle(RefId), 'Color', GUIUtils.getLineColor(RefId),...
%     'LineWidth', GUIUtils.getLineWidth(RefId));
% plots(3) = plot(ax1, corrected.Date, corrected.(dataId1), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId1), 'Color', GUIUtils.getLineColor(dataId1),...
%     'LineWidth', GUIUtils.getLineWidth(dataId1));
% plots(4) = plot(ax1, corrected.Date, corrected.(dataId2), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId2), 'Color', GUIUtils.getLineColor(dataId2),...
%     'LineWidth', GUIUtils.getLineWidth(dataId2));
% plot(ax1, C.Date, C.(dataId1), 'LineStyle',...
%     "--", 'Color', GUIUtils.getLineColor(dataId1),...
%     'LineWidth', GUIUtils.getLineWidth(dataId1));
% plot(ax1, C.Date, C.(dataId2), 'LineStyle',...
%     "--", 'Color', GUIUtils.getLineColor(dataId2),...
%     'LineWidth', GUIUtils.getLineWidth(dataId2));
% 
% ax1.FontSize = GUIUtils.FONT_SIZE_TICK;
% ax1.LineWidth(1) = GUIUtils.AXIS_WIDTH;
% ax1.Box = 'off';
% grid(ax1, 'on');
% ax1.XAxis.Visible = 'off';
% ylim(ax1,GUIUtils.LIMIT_CO2);
% ylabel(ax1, GUIUtils.VAR_CO2_ABREV+" "+GUIUtils.UNIT_PPM,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
% xlim(ax1, [startDate endDate]);
% yyaxis(ax1, 'right');
% % ax1.YAxis(2).Exponent = 0;
% % ytickformat(ax1,'%.2g');
% ylim(ax1,GUIUtils.LIMIT_CO2);
% % yticklabels(ax1,{});
% 
% % Create second plot
% ax2 = axes(t);
% ax2.Layout.Tile = 2;
% hold on;
% plot(ax2, P.Date, P.(dataId), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
%     'LineWidth', GUIUtils.getLineWidth(dataId));
% plot(ax2, P.Date, P.(RefId), 'LineStyle',...
%     GUIUtils.getLineStyle(RefId), 'Color', GUIUtils.getLineColor(RefId),...
%     'LineWidth', GUIUtils.getLineWidth(RefId));
% ytickformat(ax2,'%.2g');
% ax2.YAxis.Exponent = 0;
% ax2.FontSize = GUIUtils.FONT_SIZE_TICK;
% ax2.LineWidth(1) = GUIUtils.AXIS_WIDTH;
% ax2.Box = 'off';
% grid(ax2, 'on');
% ax2.XAxis.Visible = 'off';
% ylim(ax2, GUIUtils.LIMIT_PRES);
% ylabel(ax2, GUIUtils.VAR_PRES_ABREV+" "+GUIUtils.UNIT_PA,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
% xlim(ax2, [startDate endDate]);
% yyaxis(ax2, 'right');
% ylim(ax2,GUIUtils.LIMIT_PRES);
% ytickformat(ax2,'%.2g');
% ax2.YAxis(2).Exponent = 0;
% % yticklabels({});
% 
% % Create third plot
% ax3 = axes(t);
% ax3.Layout.Tile = 3;
% hold on;
% plots(1) = plot(ax3, T.Date, T.(chambId), 'LineStyle',...
%     GUIUtils.getLineStyle(chambId), 'Color', GUIUtils.getLineColor(chambId),...
%     'LineWidth', GUIUtils.getLineWidth(chambId));
% plot(ax3, Tin.Date, Tin.(dataId), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
%     'LineWidth', GUIUtils.getLineWidth(dataId));
% ax3.FontSize = GUIUtils.FONT_SIZE_TICK;
% ax3.LineWidth(1) = GUIUtils.AXIS_WIDTH;
% ax3.Box = 'off';
% grid(ax3, 'on');
% ax3.XAxis.Visible = 'off';
% ylim(ax3, GUIUtils.LIMIT_TEMP);
% ylabel(ax3, GUIUtils.VAR_TEMP_ABREV+" "+GUIUtils.UNIT_CELSIUS,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
% xlim(ax3, [startDate endDate]);
% yyaxis(ax3, 'right');
% ylim(ax3,GUIUtils.LIMIT_TEMP);
% % yticklabels({});
% 
% 
% % Create forth plot
% ax4 = axes(t);
% ax4.Layout.Tile = 4;
% hold on;
% plot(ax4, U.Date, U.(chambId), 'LineStyle',...
%     GUIUtils.getLineStyle(chambId), 'Color', GUIUtils.getLineColor(chambId),...
%     'LineWidth', GUIUtils.getLineWidth(chambId));
% plot(ax4, Uin.Date, Uin.(dataId), 'LineStyle',...
%     GUIUtils.getLineStyle(dataId), 'Color', GUIUtils.getLineColor(dataId),...
%     'LineWidth', GUIUtils.getLineWidth(dataId));
% ax4.FontSize = GUIUtils.FONT_SIZE_TICK;
% ax4.LineWidth(1) = GUIUtils.AXIS_WIDTH;
% ax4.Box = 'off';
% grid(ax4, 'on');
% ax4.XAxis.Visible = 'on';
% ylim(ax4, GUIUtils.LIMIT_RH);
% ylabel(ax4, GUIUtils.VAR_RH_ABREV+" "+GUIUtils.UNIT_RH,'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
% xlim(ax4, [startDate endDate]);
% xlabel(ax4, GUIUtils.VAR_TIME+" "+GUIUtils.UNIT_TIME, 'FontSize', GUIUtils.FONT_SIZE_REGULAR, 'FontName',GUIUtils.FONT_TIMESNR);
% yyaxis(ax4, 'right');
% ylim(ax4,GUIUtils.LIMIT_RH);
% % yticklabels({});
% 
% lgdStrings = {GUIUtils.getString(chambId), GUIUtils.getString(RefId), GUIUtils.getString(dataId1), GUIUtils.getString(dataId2)};
% linkaxes([ax1 ax2 ax3 ax4], 'x');
% title(t,"Joint Correction", 'FontSize', GUIUtils.FONT_SIZE_LARGER, 'FontName',GUIUtils.FONT_TIMESNR);
% lgd = legend(plots,lgdStrings, 'Orientation', 'horizontal', 'Location','layout', 'FontSize', GUIUtils.FONT_SIZE_SMALL, 'FontName',GUIUtils.FONT_TIMESNR);
% lgd.Layout.Tile = 'north';
% set(gcf,'color','w');
% 
% 
% 
% figureIndex = figureIndex+1;
end