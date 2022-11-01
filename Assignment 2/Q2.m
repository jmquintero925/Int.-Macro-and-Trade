%% Housekeeping 
clc; clear all; close all;
% Import colors (only works in my computer lol)
try
    global c
    myColors();
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["country_org", "sector_org", "sector_dest", "country_dest", "trade_flow2014"];
opts.VariableTypes = ["categorical", "double", "double", "categorical", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["country_org", "country_dest"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("Data/bilateral_trade_sector_country.csv", opts);

ccode_o = tbl.country_org;
sec_o   = tbl.sector_org; %j 
sec_d   = tbl.sector_dest; %k
ccode_d = tbl.country_dest;
tf      = tbl.trade_flow2014;
clear opts tbl

%% Question i - Housekeeping

% Drop sector 0
idx     = sec_d~=0;
ccode_o = ccode_o(idx);
sec_o   = sec_o(idx);
sec_d   = sec_d(idx);
ccode_d = ccode_d(idx);
tf      = tf(idx);
clear idx;

% Make numeric index
i = grp2idx(ccode_o);
n = grp2idx(ccode_d);

% Save dimensions
nc = length(unique(n)); % Number of countries
ns = max(sec_o); % Number of sectors

%% Question i - a

tau = zeros(nc,nc,ns-1);

%% Question i - b
% Trade flows to sector j
tX_injk     = accumarray([n,i,sec_d,sec_o],tf);
X_nij       = sum(permute(tX_injk,[1,2,4,3]),4);
X_nij       = X_nij(:,:,setdiff(1:54,51));
% Share of trade
pi_nji   = X_nij./sum(X_nij,2);

%% Question i - c
gamma_jkn = sum(permute(tX_injk,[1,3,4,2]),4,'omitnan');
gamma_jkn = gamma_jkn(:,setdiff(1:54,51),setdiff(1:54,51));
Ynj       = sum(X_nij,2,'omitnan');
gamma_jkn = gamma_jkn./permute(Ynj,[1,2,3]);
% Calculate the average for heat map 
b_gamma_jk = permute(mean(gamma_jkn,1,'omitnan'),[2,3,1]);
% Grid for heat map 
[J,K] = meshgrid(1:(ns-1));
% Make heat map 
% ---------------------------------------------------------------
figure; 
hold on
pcolor(J,K,log(b_gamma_jk));
xlim([1,53])
ylim([1,53])
xticks(10:10:50)
yticks(10:10:50)
xlabel('Sector of Origin')
ylabel('Sector of Destination')
% ----- Color bar ---------
cb = colorbar;
colormap(jet(100))
cb.Limits = log([1e-4,1]);
cb.Ticks = log([0.001,0.01,0.1,0.3,0.9]);
cb.TickLabels = strcat(["1e-3","1e-2","1e-1","3e-1","9e-1"]);
cb.Label.Interpreter = 'latex';
cb.Label.FontSize  = 15;
cb.Label.Rotation  = 90; 
cb.Label.String = 'Average Spending Shares $\bar{\gamma}^{jk}$';
% ---------------------------------------------------------------
export_fig('Figures/heatmap-ic','-pdf','-transparent'); 

%% Question i - d

gamma_nk = sum(gamma_jkn,3,'omitnan');
gamma_nk = 1 - gamma_nk/max(gamma_nk(:));

figure; 
histogram(gamma_nk,'BinWidth',0.01,'Normalization','pdf')
xlim([0,1])
xlabel('Share of value-added, $\gamma_n^k$')
ylabel('pdf')
export_fig('Figures/pdf-id','-pdf'); 

%% Question i-e

wL = sum(sum(permute(gamma_nk,[3,1,2]).*(X_nij./(1+tau)),3),1)';


%% Question i-gf
hD = sum(sum(X_nij./(1+tau),2),3)-sum(sum(X_nij./(1+tau),1),3)';

figure;
histogram(hD./wL,'BinWidth',0.05,'Normalization','pdf')
xlim([-0.3,0.3])
xlabel('Transfers as a share of value-added')
ylabel('pdf')
export_fig('Figures/pdf-if','-pdf'); 

%% 

alpha_nj = permute(sum(X_nij,2),[1,3,2]) - permute(sum(sum(permute(gamma_jkn,[4,1,2,3]).*X_nij,1),3),[2,4,1,3]);
den  = wL + hD + sum(sum(X_nij,3),2);
alpha_nj = alpha_nj./den;
alpha_j  = mean(alpha_nj,1);
