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
% cn = govt_data.Properties.VariableNames{1};
cn1 = govt_data{:,1};
G = findgroups(cn1);

cn2 = covid_case_data{:,3};
G2 = findgroups(cn2);

% Use latest Date Policies
% mystats = @(x)[min(x) median(x) max(x)];
% [uv,~,idx] = unique(XX,'stable');
% [Result, Indices] = splitapply(@max, govt_data{:,5}, G);


% Perform k-means clustering
% idx = kmeans(data, 2);