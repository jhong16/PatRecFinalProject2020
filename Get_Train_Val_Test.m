%% Split into train/validate/test data
% Test different combinations of the government policy categories
categories = [7:2:21,22,24,29:30,33]; % originally [7:2:21,22,24,29:30,33];

% First get all training/validation/test data for all of the government
% policy categories.
% Training data: use 10/17 - 10/30
% Validation data: use 10/31 - 11/06
% Testing data: use 11/07 - 11/20


countries = unique(OxCGRT(:,1)); % Alphebetizes countries
n = size(countries,1);

% Tracks the amount for the selected categories, averaged over the dates
train_safe = zeros(length(safe_countries),length(categories));
train_unsafe = zeros(length(unsafe_countries),length(categories));

val_safe = zeros(length(safe_countries),length(categories));
val_unsafe = zeros(length(unsafe_countries),length(categories));

test_safe = zeros(length(safe_countries),length(categories));
test_unsafe = zeros(length(unsafe_countries),length(categories));

track_safe_names = cell(length(safe_countries),1); j = 1;
track_unsafe_names = cell(length(unsafe_countries),1); k = 1;

for i = 1:height(countries)
    % For each country
    c = countries.CountryName(i);
    country_data = OxCGRT(strcmp(OxCGRT.CountryName,c),:);
    
    % Train data: 10/17 - 10/30
    loc1_train = find(country_data.('Date')==20201017, 1);
    loc2_train = find(country_data.('Date')==20201030, 1);
    tot_train = sum(country_data{loc1_train:loc2_train,categories},1)/(loc2_train-loc1_train);
    
    % Validation data: 10/31 - 11/06
    loc1_val = find(country_data.('Date')==20201031, 1);
    loc2_val = find(country_data.('Date')==20201106, 1);
    tot_val = sum(country_data{loc1_val:loc2_val,categories},1)/(loc2_val-loc1_val);
    
    % Test data: 11/07 - 11/20
    loc1_test = find(country_data.('Date')==20201107, 1);
    loc2_test = find(country_data.('Date')==20201120, 1);
    tot_test = sum(country_data{loc1_test:loc2_test,categories},1)/(loc2_test-loc1_test);
    
    if(ismember(c,safe_countries)) % If classified as safe
        train_safe(j,1:length(categories)) = tot_train;
        val_safe(j,1:length(categories)) = tot_val;
        test_safe(j,1:length(categories)) = tot_test;
        
        track_safe_names(j) = c;
        j = j+1;
    else % If classified as unsafe
        train_unsafe(k,1:length(categories)) = tot_train;
        val_unsafe(k,1:length(categories)) = tot_val;
        test_unsafe(k,1:length(categories)) = tot_test;
        
        track_unsafe_names(k) = c;
        k = k+1;
    end
end

% train_safe_with_names = table(track_safe_names,train_safe); %,'VariableNames',{'Var1','Var2'});
% train_unsafe_with_names = table(track_unsafe_names,train_unsafe); %,'VariableNames',{'Var1','Var2'});



%% Set up to use with a Neural Network

% Label vectors. +1: Safe; -1: Unsafe.
train_label = [ones(1,size(train_safe,1)),-1*ones(1,size(train_unsafe,1))];
val_label = [ones(1,size(val_safe,1)),-1*ones(1,size(val_unsafe,1))];
test_label = [ones(1,size(test_safe,1)),-1*ones(1,size(test_unsafe,1))];

% Apply same pre-processing steps for all three datasets.
train_data = normalize([train_safe;train_unsafe],1);
val_data = normalize([val_safe;val_unsafe],1);
test_data = normalize([test_safe;test_unsafe],1);


% Create a combined matrix of data and labels that will be used in the
% ‘train’ function during training.
data = [train_data; val_data; test_data].';
label = [train_label, val_label, test_label];

