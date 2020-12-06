% k_means.m
% Perform the Binary Clustering of countries based on covid and government
% policy data

% Covid Case Data
opts = detectImportOptions('covid-case-data.xlsx');
covid_case_data = readtable('covid-case-data.xlsx');

% Data Parsing
% Government Policy Data
opts = detectImportOptions('govt-policy-data.xlsx');
govt_data = readtable('govt-policy-data.xlsx', opts);

%% Group Data by Country Name
% Grouping by Country Name
cn1 = govt_data{:,1};
cn2 = govt_data{:,2};
regions = govt_data{:,3}; % US States
% US States Split
for i = 1:length(cn1)
    if isempty(govt_data{i,3}{1}) % if no region name, make it the country name
        regions{i} = govt_data{i,1}{1};
    end
end
[country_group, country_name, cc, region_name] = findgroups(cn1, cn2, regions);


%% Government Data Combination Policy
% Given the same start-date for tracking as covid-case data
% Take an average of:
% Col 6: School Closing
% Col 8: Workplace Closing
% Col 10: Cancel Public Events
% Col 12: Restrict Gatherings
% Col 14: Close Public Transport
% Col 16: Stay at Home Requirements
% Col 18: Restrictions on Internal Movement
% Col 20: Restrict Int'l Travel
% Col 21: Income Support
% Col 23: Debt Contract Relief
% Col 24: Fiscal Measures
% Col 25: Int'l Support
% Col 26: Public Info Campaigns
% Col 28: Testing Policy
% Col 29: Contact Tracing
% Col 30: Emergency Investment in Healthcare
% Col 31: Investment in Vaccines
% Col 32: Facial Coverings

% All these categories have scales where the higher the value, the more
% stringent the policy is

mystats = @(x) mean(x(~isnan(x)));
school = splitapply(mystats, govt_data{:,6}, country_group);
work = splitapply(mystats, govt_data{:,8}, country_group);
public_event = splitapply(mystats, govt_data{:,10}, country_group);
gathering = splitapply(mystats, govt_data{:,12}, country_group);
public_transport = splitapply(mystats, govt_data{:,14}, country_group);
stay_at_home = splitapply(mystats, govt_data{:,16}, country_group);
internal_mvmt = splitapply(mystats, govt_data{:,18}, country_group);
intl_mvmt = splitapply(mystats, govt_data{:,20}, country_group);
income_support = splitapply(mystats, govt_data{:,21}, country_group);
debt_relief = splitapply(mystats, govt_data{:,23}, country_group);
fiscal_measures = splitapply(mystats, govt_data{:,24}, country_group);
intl_support = splitapply(mystats, govt_data{:,25}, country_group);
public_info = splitapply(mystats, govt_data{:,26}, country_group);
testing_policy = splitapply(mystats, govt_data{:,28}, country_group);
contact_tracing = splitapply(mystats, govt_data{:,29}, country_group);
emgnc_health = splitapply(mystats, govt_data{:,30}, country_group);
invest_vaccine = splitapply(mystats, govt_data{:,31}, country_group);
facial_covering = splitapply(mystats, govt_data{:,32}, country_group);



gov_stats = table(country_name, region_name, school, work, ...
public_event, gathering, public_transport, stay_at_home, internal_mvmt, ...
intl_mvmt, income_support, debt_relief, fiscal_measures, intl_support, ...
public_info, testing_policy, contact_tracing, emgnc_health, ...
invest_vaccine, facial_covering);

t2 = gov_stats{:,3:end};
t2(isnan(t2)) = 0;
gov_stats{:,3:end} = t2;

data = gov_stats{:, 3:end};
% Perform k-means clustering
classification = kmeans(data, 2);


gov_stats = addvars(gov_stats, classification,'Before','country_name');

% Grouping by Country Name
cn2 = covid_case_data{:,3};
G2 = findgroups(cn2);


