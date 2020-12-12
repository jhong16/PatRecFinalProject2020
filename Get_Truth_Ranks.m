

%% OxCGRT

countries = unique(OxCGRT(:,1)); % Alphebetizes countries
n = size(countries,1);

% Get the number of entries by date
lowbound = find(OxCGRT.('Date')==20200123, 1);
upbound = find(OxCGRT.('Date')==20201120, 1); % Changed from 11/30 to 11/20

% Tracks the totals over all of the categories at each date
totals_OxCGRT = zeros(height(countries),upbound);

for i = 1:height(countries)
    % For each country
    c = countries.CountryName(i);
    country_data = OxCGRT(strcmp(OxCGRT.CountryName,c),:);
    
    % Get the columns for the first and last date for the country
    loc1 = find(country_data.('Date')==20200123, 1);%loc1=loc1(end);
    loc2 = find(country_data.('Date')==20201120, 1);%loc2=loc2(end); % Changed from 11/30 to 11/20
    
    tot = sum(country_data{loc1:loc2,[7:2:21,22,24,29:30,33]},2); % May remove 24
    
    totals_OxCGRT(i,lowbound:upbound) = tot;
    
end

totals_OxCGRT = table(countries.CountryName,totals_OxCGRT);

%% OneWorld

% Daily case rate zones classified by rate = (# new cases)/(100,000 residents)
% --> Examine (# new cases)/(total population)

countries = unique(OurWorld(:,3));

% Get the number of entries by date
lowbound = find(OurWorld.('date')==datetime([2020,01,23]), 1);
upbound = find(OurWorld.('date')==datetime([2020,11,20]), 1);

% Tracks the totals over all of the categories at each date
totals_OurWorld = zeros(height(countries),upbound);

for i = 1:height(countries)
    % For each country
    c = countries.location(i);
    country_data = OurWorld(strcmp(OurWorld.location,c),:);
    
    % Get the columns for the first and last date for the country
    loc1 = find(OurWorld.('date')==datetime([2020,01,23]), 1);
    loc2 = find(OurWorld.('date')==datetime([2020,11,20]), 1);
    
    rate = country_data{loc1:loc2,12}; % Column 12: new cases per million
    
    totals_OurWorld(i,lowbound:upbound) = rate;
    
end

totals_OurWorld = table(countries.location,totals_OurWorld);


%% Determine 'safe' and 'unsafe' countries

% Top 20% = 'safe'; Bottom 80% = 'unsafe'

% Examine number of new cases in the last month for each country
[~,idx] = sort(sum(totals_OurWorld.Var2(:,end-30:end),2));

top20_countries = countries.location(idx(1:floor(n*0.20)));
bottom80_countries = countries.location(idx(floor(n*0.20)+1:end));

% [Government policy total; case total]
top20 = [sum(totals_OxCGRT.Var2(idx(1:floor(n*0.20)),end-30:end),2)/31,...
        sum(totals_OurWorld.Var2(idx(1:floor(n*0.20)),end-30:end),2)/31];
bottom80 = [sum(totals_OxCGRT.Var2(idx(floor(n*0.20)+1:end),end-30:end),2)/31,...
        sum(totals_OurWorld.Var2(idx(floor(n*0.20)+1:end),end-30:end),2)/31];


% Normalize data
T = normalize([top20;bottom80],1);
top20_normalized = T(1:floor(n*0.20),:);
bottom80_normalized = T(floor(n*0.20)+1:end,:);

% safe = normalize(top20,1);
% unsafe = normalize(bottom80,1);
