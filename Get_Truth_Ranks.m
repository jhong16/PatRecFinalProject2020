
countries = unique(OxCGRT(:,1));

% Get the number of entries by date
lowbound = find(OxCGRT.('Date')==20200101, 1);
upbound = find(OxCGRT.('Date')==20201130, 1);

% Tracks the totals over all of the categories at each date
totals = zeros(height(countries),upbound);


for i = 1:height(countries)
    % For each country
    
    % Get the columns for the first and last date for the country
    loc1 = find(OxCGRT.('Date')==20200101, i);loc1=loc1(end);
    loc2 = find(OxCGRT.('Date')==20201130, i);loc2=loc2(end);
    
    tot = sum(OxCGRT{loc1:loc2,[7:2:21,22,24,27,29:30,33]},2);
    
    totals(i,lowbound:upbound) = tot;
    
end

