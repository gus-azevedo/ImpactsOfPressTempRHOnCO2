%%------------------
% Author: Gustavo B. H. de Azevedo
%------------------
clear; close all; clc;
format longG;

%%------------------
% INSERT PATH TO DATA FOLDER BELOW
% DATA_FOLDER = "./myDataExample";
%------------------

%%------------------
% SELECT EXPERIMENT TYPE
% TYPE = Constants.BENCH;
  TYPE = Constants.MESONET;
%------------------



[P, T, U, C, T_IN, U_IN, PPT] = fxFileLoad(TYPE, DATA_FOLDER);



%%------------------
% [OPTIONAL]: FUNCTION TO READ RAW DATA
%%------------------
% [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataBench(DATA_FOLDER, SYSTEM);
% [P, T, U, C, T_IN, U_IN] = fxFileReadExpDataMesonet(DATA_FOLDER, SYSTEM);
%%------------------

