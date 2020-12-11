
%% Load data sets

% Load OxCGRT data: 01/01/2020 - 11/30/2020
OxCGRT = readtable('OxCGRT_data.csv');
OxCGRT = removevars(OxCGRT,{'Var1'});

% Set NaN variables to 0
vars = OxCGRT.Properties.VariableNames(7:47);
t2 = OxCGRT{:,vars};
t2(isnan(t2)) = 0;
OxCGRT{:,vars} = t2;


% Load OurWorld data: 01/23/2020 - 12/08/2020
OurWorld = readtable('ourworld_data.csv');

% Remove blank columns: 17-34,42,45-46
OurWorld = removevars(OurWorld,OurWorld.Properties.VariableNames(45:46));
OurWorld = removevars(OurWorld,OurWorld.Properties.VariableNames(42));
OurWorld = removevars(OurWorld,OurWorld.Properties.VariableNames(17:34));

% Set NaN variables to 0
vars = OurWorld.Properties.VariableNames(5:16);
t2 = OurWorld{:,vars};
t2(isnan(t2)) = 0;
OurWorld{:,vars} = t2;


%% Condense data sets to range: 01/23/2020 - 11/30/2020

% Remove dates earlier than 01/23/2020 from OxCGRT:
idx = OxCGRT.Date < 20200123 | OxCGRT.Date > 20201130;
OxCGRT(idx,:) = [];

% Remove dates later than 12/01/2020 from OurWorld:
idx = OurWorld.date > datetime([2020,11,30]);
OurWorld(idx,:) = [];


%% Remove data from unique countries
% (Remove data from countries that aren't included in the other data set)
countries_OxCGRT = unique(OxCGRT.CountryName);
countries_OurWorld = unique(OurWorld.location);

p=ismember(countries_OxCGRT,countries_OurWorld);
first_set=countries_OxCGRT(~p); % In countries_OxCGRT, not in countries_OurWorld

p=ismember(countries_OurWorld,countries_OxCGRT);
second_set=countries_OurWorld(~p); % In countries_OurWorld, not in countries_OxCGRT

idx = ismember(OxCGRT.CountryName,first_set);
OxCGRT(idx,:) = [];

idx = ismember(OurWorld.location,second_set);
OurWorld(idx,:) = [];

% Remove Hong Kong data: data is scattered/missing in OurWorld data set
idx = ismember(OxCGRT.CountryName,'Hong Kong');
OxCGRT(idx,:) = [];

idx = ismember(OurWorld.location,'Hong Kong');
OurWorld(idx,:) = [];


