
% Load OxCGRT data
OxCGRT = readtable('OxCGRT_data.csv');
OxCGRT = removevars(OxCGRT,{'Var1'});

vars = OxCGRT.Properties.VariableNames(7:47);
t2 = OxCGRT{:,vars};
t2(isnan(t2)) = 0;
OxCGRT{:,vars} = t2;
