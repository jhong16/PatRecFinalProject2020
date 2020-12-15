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

% Population Data
opts = detectImportOptions('country-populations.xlsx');
pop_data = readtable('country-populations.xlsx', opts);

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
[country_group, country_name, cc] = findgroups(cn1, cn2);


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



gov_stats = table(country_name, country_name, school, work, ...
public_event, gathering, public_transport, stay_at_home, internal_mvmt, ...
intl_mvmt, income_support, debt_relief, fiscal_measures, intl_support, ...
public_info, testing_policy, contact_tracing, emgnc_health, ...
invest_vaccine, facial_covering);

t2 = gov_stats{:,3:end};
t2(isnan(t2)) = 0;
gov_stats{:,3:end} = t2;

% Round 1
% data = gov_stats{:, 3:end};

% Round 2, no fiscal measures, 
% data = gov_stats{:, 3:12};
% data = [data gov_stats{:, 14:end}];

% Round 3, no fiscal measures, no international support
% data = gov_stats{:, 3:12};
% data = [data gov_stats{:, 15:end}];

% Round 4, and no emergency health spending
data = gov_stats{:, 3:12};
data = [data gov_stats{:, 15:17}];
data = [data gov_stats{:, 20}];


% Perform k-means clustering
classification = kmeans(data, 2);

gov_stats = addvars(gov_stats, classification,'Before','country_name');

disp("Sum of Class 2 countries")
disp(sum(classification == 2));
disp("Sum of Class 1 countries")
disp(sum(classification == 1));

% Correlating government measures to lower number of new cases.
% Need to mark the dates of downward trends and then sample the same dates
% as the government policies and maybe up to a month before that downward
% trend.

%% Covid Case Data


% Grouping by Country Name
cn2 = covid_case_data{:,3};
[country_group, country_name] = findgroups(cn2);

mystats = @(x) mean(x(~isnan(x)));

% Data Columns
% Column 5: Total Cases
% Column 6: New Cases
% Column 7: New Cases Smoothed
% Column 8: Total Deaths
% Column 9: New Deaths
% Column 10: New Deaths Smoothed
% Column 11: Total Cases per Million
% Column 12: New Cases per Million
% Column 13: New Cases Smoothed per Million
% Column 14: Total Deaths per Million
% Column 15: New Deaths per Million
% Column 16: New Deaths Smoothed per Million
% Column 17: ICU patients
% Column 18: ICU patients per million
% Column 19: Hospital Patients
% Column 20: Hospital Patients per Million
% Column 21: Weekly ICU Admissions
% Column 22: Weekly ICU Admissions per Million
% Column 23: Weekly Hospital Admissions
% Column 24: Weekly Hospital Admissions per Million
% Column 25: Total Tests
% Column 26: New Tests
% Column 27: Total Tests per thousand
% Column 28: New Tests per thousand
% Column 29: New Tests Smoothed
% Column 30: New Tests Smoothed per thousand
% Column 31: Tests per Case
% Column 32: Positive Rate
% Column 33: Tests Units 
% Column 34: Stringency Index
% Column 35: Population
% Column 36: Population Density
% Column 37: Median Age
% Column 38: Aged 65 or older
% Column 39: Aged 70 or older
% Column 40: GDP per capita
% Column 41: Extreme Poverty
% Column 42: Cardiovascular Death Rate
% Column 43: Diabetes Prevalence
% Column 44: Female Smokers
% Column 45: Male Smokers
% Column 46: Handwashing Facilities
% Column 47: Hospital Beds per thousand
% Column 48: Life Expectancy
% Column 49: Human Development Index


% Normalized Data
% % Column 12: New Cases per Million
% % Column 15: New Deaths per Million
% % Column 18: ICU patients per million
% % Column 20: Hospital Patients per Million
% % Column 22: Weekly ICU Admissions per Million
% % Column 24: Weekly Hospital Admissions per Million
% % Column 28: New Tests per thousand
% % Column 31: Tests per Case
% % Column 32: Positive Rate
% % Column 33: Tests Units 
% % Column 34: Stringency Index

% Constants per Country
% % Column 35: Population
% % Column 36: Population Density
% % Column 37: Median Age
% % Column 38: Aged 65 or older
% % Column 39: Aged 70 or older
% % Column 40: GDP per capita
% % Column 41: Extreme Poverty
% % Column 42: Cardiovascular Death Rate
% % Column 43: Diabetes Prevalence
% % Column 44: Female Smokers
% % Column 45: Male Smokers
% % Column 46: Handwashing Facilities
% % Column 47: Hospital Beds per thousand
% % Column 48: Life Expectancy
% % Column 49: Human Development Index

%Latest Totals
% Column 11: Total Cases per Million
% Column 14: Total Deaths per Million
% Column 27: Total Tests per thousand

% Relevant indices to take average
% Column 6: New Cases
% Column 9: New Deaths
mean_indices = [6, 9];

% Relevant indices per million to take average
mean_indices2 = [12, 15, 18, 20, 22, 24, 28, 31, 32, 33, 34]; 
    
% Relevant constants per country
const_indices = [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49];

% Latest Totals
latest_indices = [11, 14, 27];

case_stats = table(country_name);

for i = 1:length(mean_indices)
    index = mean_indices(i);
    case_stats.(cell2mat(covid_case_data.Properties.VariableNames(index))) ...
        = splitapply(mystats, covid_case_data{:,index}, country_group2);
end

for i = 1:length(mean_indices2)
    index = mean_indices2(i);
    case_stats.(cell2mat(covid_case_data.Properties.VariableNames(index))) ...
        = splitapply(mystats, covid_case_data{:,index}, country_group2);
end

for i = 1:length(latest_indices)
    index = latest_indices(i);
    case_stats.(cell2mat(covid_case_data.Properties.VariableNames(index))) ...
        = splitapply(@max, covid_case_data{:,index}, country_group2);
end

% Column 6, 7, 8, 9, 10, 13 incomplete
% Column 11, 12, 17 semi-incomplete

%% K-means

case_stats.Properties.RowNames = case_stats.country_name;
% case_stats.country_name = [];


% Delete International and then World Row
case_stats('International',:) = [];
case_stats('World',:) = [];

% round 1
% data = case_stats{:, 1:4};
% data = [data case_stats{:, 10:11}];
% data = [data case_stats{:, 13:16}];

% Round 2
% data = case_stats{:, 1:4};
% data = [data case_stats{:, 13:16}];

% Round 3
% data = case_stats{:, 1:4};

% Round 4
data = case_stats{:, 4:5};

% Perform k-means clustering
[idx, C] = kmeans(data, 2);

figure;
plot(data(idx==1,1),data(idx==1,2),'r.','MarkerSize',12)
hold on
plot(data(idx==2,1),data(idx==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
xlabel("new cases per million");
ylabel("New deaths per million");
hold off

case_stats = addvars(case_stats, idx,'Before','new_cases');

%% Further Analysis

covid_case_classification = case_stats(:, 1:2);
govt_classification = gov_stats(:, 1:2);

class_table = outerjoin(covid_case_classification, govt_classification);

% Remove Any Unmatchable Countries
class_table = class_table(~any(ismissing(class_table), 2), :);
covid_labels = table2array(class_table(:,2)); %1 is lower cases, 2 is higher cases
gov_labels = table2array(class_table(:,3)); %1 is more government policies, 2 is lower gov't policies
C = confusionmat(covid_labels, gov_labels);
disp(C);

confusionchart(covid_labels,gov_labels)
ylabel("covid case data where 1: Less Cases, 2: More Cases");
xlabel("gov't policy data where 1: More Policies, 2: Less Policies");

comb_stats = outerjoin(case_stats, gov_stats, 'Keys', 'country_name');

%% Stringent and Joint
stringent_data = comb_stats{:, 5:6};
stringent_data = [stringent_data comb_stats{:, 15}];
[idx, C] = kmeans(stringent_data, 2);

stringent_stats = addvars(comb_stats, idx,'Before','country_name_case_stats');

% All Relevant columns from both
all_data = comb_stats{:, 5:6};
all_data = [all_data comb_stats{:, 22:31}];
all_data = [all_data comb_stats{:, 34:36}];
all_data = [all_data comb_stats{:, 39}];

[idx, C] = kmeans(all_data, 2);

all_stats = addvars(comb_stats, idx,'Before','country_name_case_stats');
all_stats = movevars(all_stats, 'classification', 'Before', 'new_cases');

