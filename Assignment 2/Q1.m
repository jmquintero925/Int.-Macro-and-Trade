%% Setup the Import Options and import the data
clear all; close all; clc;
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["country_org", "country_dest", "trade_flow2014"];
opts.VariableTypes = ["categorical", "categorical", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["country_org", "country_dest"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("Data/bilateral_trade_country.csv", opts);

country_org = tbl.country_org;
country_dest = tbl.country_dest;
tf = tbl.trade_flow2014;
clear opts tbl

%% Create trade objects

ccode = categories(country_org);
nc    =  length(ccode);

% Trade flows
Xn = reshape(tf,nc,nc);
% Income-to-spending ratio
yn = (sum(Xn,1)')./sum(Xn,2);
% Share of Trade 
pi = Xn./sum(Xn,2);



%% Question ii

% Initial hats before shock 
theta = 4; 
T     = ones(1,nc);
L     = ones(1,nc);
d     = ones(nc);
D     = ones(1,nc);
% Shock China producitivity
T(strcmp(ccode,"CHN")) = 1.1;
% Get not USA index
idx = find(strcmp(ccode,"USA"));
% Set tolerance and updating parameter
tol     = 1e-6;
kappa   = 1e-2;
error   = 10;
% Guess wages
w     = ones(1,nc); 
% Begin loop
while(error>tol)
    % Calculate excess demand
    num = T.*(d.*w).^(-theta);
    Z   = (Xn./sum(Xn,1)).*(num./sum(pi.*num,2));
    Z   = sum(Z.*(yn.*w' + (1-yn)),1)-w;
    % Update wages
    w = w + kappa*Z;
    % Get new error
    error = max(abs(Z)); 
    w(idx) = 1; 
end


%% Question iii

% Get price index hat
P   = (sum(pi.*T.*(d.*w).^(-theta),2)).^(-1/theta);
P   = P';
% Get hat
pi_hat  = T.*(d.*w./(P')).^(-theta);
% Real stuff
wr = w./P;

figure;
plot(wr,'Color',c.maroon)
xlim([1,42])
xticks(1:42)
xticklabels(ccode)
ax = gca;
ax.XTickLabelRotation = 90;
ax.XAxis.FontSize = 10;
ylabel('Change in Wage, $\hat{w}$')
xlabel('Country','FontSize',15)
export_fig('Figures/w_hat','-pdf'); 

reg1 = fitlm(log(diag(pi_hat)),wr');
reg2 = fitlm((-1/theta)*log(P'),wr');
reg3 = fitlm(pi(strcmp(ccode,"CHN"),:),wr');

% Export table
tab = [table2array(reg1.Coefficients(2,1:2))',nan(2);...
       nan(2,1),table2array(reg2.Coefficients(2,1:2))',nan(2,1);...
       nan(2),table2array(reg3.Coefficients(2,1:2))';
       [table2array(reg1.Coefficients(1,1:2)); ...
       table2array(reg2.Coefficients(1,1:2));...
       table2array(reg3.Coefficients(1,1:2))]'];
   
latex.data = tab;
latex.tableCaption = 'Regressions';
latex.tableLabel = 'reg';
latex.tablePositioning = 'htb';
latex.tableColumnAlignment = 'c';
latex.tableBorders = 0;
latex.dataFormat = {'%2.3f'};
latex.tableColLabels = {'$\sfrac{\hat{w}}{\hat{P}}$','$\sfrac{\hat{w}}{\hat{P}}$','$\sfrac{\hat{w}}{\hat{P}}$'};
latex.tableRowLabels = {'$\ln\hat{\pi}_{ii}$','','$\ln\hat{\Phi}_i$',...
                        '','$\pi^0_{i\text{China}}$','','Constant',''};
latex = latexTable2(latex);
dlmcell(strcat('Tables/momentsTab.tex'),latex)
 

 

%% Question iv


% Guess wages
w     = ones(1,nc); 
% Begin loop
while(error>tol)
    % Calculate excess demand
    num = T.*(d.*w).^(-theta);
    Z   = (Xn./sum(Xn,1)).*(num./sum(pi.*num,2));
    Z   = sum(Z.*(yn.*w' + (1-yn)*w(strcmp(ccode,"CHN"))),1)-w;
    % Update wages
    w = w + kappa*Z;
    % Get new error
    error = max(abs(Z)); 
    w(idx) = 1; 
end

P   = (sum(pi.*T.*(d.*w).^(-theta),2)).^(-1/theta);
P   = P';

% Real stuff
wr = w./P;


figure;
plot(wr,'Color',c.maroon)
xlim([1,42])
xticks(1:42)
xticklabels(ccode)
ax = gca;
ax.XTickLabelRotation = 90;
ax.XAxis.FontSize = 10;
ylabel('Change in Wage, $\hat{w}$')
xlabel('Country','FontSize',15)
export_fig('Figures/w_hat2','-pdf'); 
