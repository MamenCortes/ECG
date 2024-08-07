%S_DIA1_2024-05-17_09-57-48
%Toolboxes needed: Statistic and Machine Learning Toolbox, Signal Processing Toolbox; 

%Variable que indicará si se está realizando un text o no --> definirá el
%tamaño de muestra que se procesará.
TEST = 1; 

if(TEST)
 time_vector = 1:((2*60)*1000); %Tiempo en milisegundos = 2 minutos
else
 time_vector = 1:(((8*60)*60)*1000); %tiempo en milisegundos = 8 horas
end
   

%Variables iniciales que definen los archivos txt y el tiempo que se tomará
%de muestra de los archivos. 
files_M = {'Top\M\M_DIA1_2024-05-14_07-45-49.txt', 'Top\M\M_DIA2_2024-05-21_08-17-33.txt', 'Top\M\M_DIA3_2024-05-24_09-58-13.txt', 'Top\M\M_DIA4_2024-06-02_09-08-18.txt'};
files_S = {'Top\S\S_DIA1_2024-05-17_09-57-48.txt', 'Top\S\S_DIA2_2024-05-22_07-30-33.txt', 'Top\S\S_DIA3_2024-05-25_09-31-38.txt', 'Top\S\S_DIA4_2024-06-03_09-38-01.txt'}; 
files_L = {'Top\L\L_DIA1_2024-05-16_10-03-55.txt', 'Top\L\L_DIA2_2024-05-20_09-58-30.txt', 'Top\L\L_DIA3_2024-05-30_10-29-44.txt', 'Top\L\L_DIA4_2024-06-07_12-49-23.txt'};

fileSets = {files_S, files_M, files_L}; 
fileSets2 = {'Top\S\S_DIA1_2024-05-17_09-57-48.txt', 'Top\S\S_DIA2_2024-05-22_07-30-33.txt', 'Top\S\S_DIA3_2024-05-25_09-31-38.txt', 'Top\S\S_DIA4_2024-06-03_09-38-01.txt', 'Top\M\M_DIA1_2024-05-14_07-45-49.txt', 'Top\M\M_DIA2_2024-05-21_08-17-33.txt', 'Top\M\M_DIA3_2024-05-24_09-58-13.txt', 'Top\M\M_DIA4_2024-06-02_09-08-18.txt', 'Top\L\L_DIA1_2024-05-16_10-03-55.txt', 'Top\L\L_DIA2_2024-05-20_09-58-30.txt', 'Top\L\L_DIA3_2024-05-30_10-29-44.txt', 'Top\L\L_DIA4_2024-06-07_12-49-23.txt'};
indexes = cell(1, length(fileSets)); % vector de 3 posiciones
indexes2 = cell(1, length(fileSets2)); %vector de 12 posiciones
file_names = {'S_DIA1', 'S_DIA2', 'S_DIA3', 'S_DIA4', 'M_DIA1', 'M_DIA2', 'M_DIA3', 'M_DIA4', 'L_DIA1', 'L_DIA2', 'L_DIA3', 'L_DIA4'};
T = table('Size', [0 12], 'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'}, 'VariableNames', file_names);

% Loop sobre cada archivo
index = 1; 
for setIndex = 1: length(indexes)
    currentFiles = fileSets{setIndex};% ej: currentFiles= fileSets{1} -> files_M ->(...,...,....,....)
    indexes{setIndex} = cell(1, length(currentFiles)); % indexes{1}= a un vector con 4 pos 

    for fileIndex = 1:4 % fileIndex = 1:length(currentFiles)=4

        data = ImportPluxData(currentFiles{fileIndex}, 3);
        ecg = data(time_vector);
        [kSQI_01_vector, sSQI_01_vector, pSQI_01_vector, rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector, dSQI_01_vector, geometricMean_vector, averageGeometricMean] = mSQI(ecg, 1000);
        indexes{setIndex}{fileIndex} = geometricMean_vector;
        indexes2{index} = geometricMean_vector'; 
        fprintf("Average mean of windows of %s: %f\n", currentFiles{fileIndex}, averageGeometricMean);
        index = index +1; 
    end
end

%Almacenar los índices en una archivo csv.
T = table('Size', [0 12], 'VariableTypes', repmat({'double'}, 1, 12), 'VariableNames', file_names);
for i = 1:length(indexes2)
    for j = 1:length(indexes2{i})
        % Pre-llenar las filas si es necesario
        if size(T, 1) < j
            T{j, :} = NaN; % Asegurarse de que todas las columnas tengan valores
        end
       T{j, file_names(i)} = indexes2{i}(j);  % Actualizar la fila existente
    end
end
writetable(T, 'mSQI_geometricMean.csv');

indexes_topL = indexes{3};
indexes_topM = indexes{2};
indexes_topS = indexes{1};


%significance level for calculating the confidence intervals
alph = 0.01;
%number of iterations to use in boostrap
iter = 1000;

% Data for the Comparison Within Each Register
% data of topL that will be used for the CI
data_topL_R2R3R4 =[indexes_topL{2},indexes_topL{3},indexes_topL{4}]; % data_topL_R2R3R4 -> R2:register2, R3:register3, R4:register of  of topL
data_topL_R1R3R4 =[indexes_topL{1},indexes_topL{3},indexes_topL{4}];
data_topL_R1R2R4 =[indexes_topL{1},indexes_topL{2},indexes_topL{4}];
data_topL_R1R2R3 =[indexes_topL{1},indexes_topL{2},indexes_topL{3}];

% data of topM that will be used for the CI
data_topM_R2R3R4 =[indexes_topM{2},indexes_topM{3},indexes_topM{4}]; % data_topM_R2R3R4 -> R2:register2, R3:register3, R4:register of topM
data_topM_R1R3R4 =[indexes_topM{1},indexes_topM{3},indexes_topM{4}];
data_topM_R1R2R4 =[indexes_topM{1},indexes_topM{2},indexes_topM{4}];
data_topM_R1R2R3 =[indexes_topM{1},indexes_topM{2},indexes_topM{3}];

% data of topS that will be used for the CI
data_topS_R2R3R4 =[indexes_topS{2},indexes_topS{3},indexes_topS{4}]; % data_topS_R2R3R4 -> R2:register2, R3:register3, R4:register of topS
data_topS_R1R3R4 =[indexes_topS{1},indexes_topS{3},indexes_topS{4}];
data_topS_R1R2R4 =[indexes_topS{1},indexes_topS{2},indexes_topS{4}];
data_topS_R1R2R3 =[indexes_topS{1},indexes_topS{2},indexes_topS{3}];


% Data for the Comparison Across Registers
data_topLvstopM_topS=cell2mat([indexes_topM,indexes_topS]); % cell2mat-> convert the contents of a cell array into a single matrix
data_topMvstopL_topS=cell2mat([indexes_topL,indexes_topS]);
data_topSvstopL_topM=cell2mat([indexes_topL,indexes_topM]);


%CONFIDENCE INTERVALS (CI)
% Comparison Within Each Register of TopM Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topM_R1vsR2R3R4 = estimateCIMedian(indexes_topM{1},data_topM_R2R3R4,alph,iter);
CIMean_topM_R1vsR2R3R4 = estimateCIMean(indexes_topM{1},data_topM_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topM_R2vsR1R3R4 = estimateCIMedian(indexes_topM{2},data_topM_R1R3R4,alph,iter);
CIMean_topM_R2vsR1R3R4 = estimateCIMean(indexes_topM{2},data_topM_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topM_R3vsR1R2R4 = estimateCIMedian(indexes_topM{3},data_topM_R1R2R4,alph,iter);
CIMean_topM_R3vsR1R2R4 = estimateCIMean(indexes_topM{3},data_topM_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topM_R4vsR1R2R3 = estimateCIMedian(indexes_topM{4},data_topM_R1R2R3,alph,iter);
CIMean_topM_R4vsR1R2R3 = estimateCIMean(indexes_topM{4},data_topM_R1R2R3,alph,iter);

% Comparison Within Each Register of TopS Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topS_R1vsR2R3R4 = estimateCIMedian(indexes_topS{1},data_topS_R2R3R4,alph,iter);
CIMean_topS_R1vsR2R3R4 = estimateCIMean(indexes_topS{1},data_topS_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topS_R2vsR1R3R4 = estimateCIMedian(indexes_topS{2},data_topS_R1R3R4,alph,iter);
CIMean_topS_R2vsR1R3R4 = estimateCIMean(indexes_topS{2},data_topS_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topS_R3vsR1R2R4 = estimateCIMedian(indexes_topS{3},data_topS_R1R2R4,alph,iter);
CIMean_topS_R3vsR1R2R4 = estimateCIMean(indexes_topS{3},data_topS_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topS_R4vsR1R2R3 = estimateCIMedian(indexes_topS{4},data_topS_R1R2R3,alph,iter);
CIMean_topS_R4vsR1R2R3 = estimateCIMean(indexes_topS{4},data_topS_R1R2R3,alph,iter);

% Comparison Within Each Register of TopL Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topL_R1vsR2R3R4 = estimateCIMedian(indexes_topL{1},data_topL_R2R3R4,alph,iter);
CIMean_topL_R1vsR2R3R4 = estimateCIMean(indexes_topL{1},data_topL_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topL_R2vsR1R3R4 = estimateCIMedian(indexes_topL{2},data_topL_R1R3R4,alph,iter);
CIMean_topXS_R2vsR1R3R4 = estimateCIMean(indexes_topL{2},data_topL_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topL_R3vsR1R2R4 = estimateCIMedian(indexes_topL{3},data_topL_R1R2R4,alph,iter);
CIMean_topL_R3vsR1R2R4 = estimateCIMean(indexes_topL{3},data_topL_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topL_R4vsR1R2R3 = estimateCIMedian(indexes_topL{4},data_topL_R1R2R3,alph,iter);
CIMean_topL_R4vsR1R2R3 = estimateCIMean(indexes_topL{4},data_topL_R1R2R3,alph,iter);


% Histograms for each register of TopM
for i = 1:4
    figure;
    histogram(indexes_topM{i}, 20);
    xlabel('mSQI Values');
    ylabel('count'); % ASK MAS INTERPRETACION
    title(['Histogram for indexes\_topM{' num2str(i) '}']);
end

% Histograms for each register of TopS
for i = 1:4
    figure;
    histogram(indexes_topS{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram for indexes\_topS{' num2str(i) '}']);
end

% Histograms for each register of TopXS
for i = 1:4
    figure;
    histogram(indexes_topL{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram for indexes\_topL{' num2str(i) '}']);
end


%Cambiar XS por L -----------------------------------------------
indexes_topM_v = cell2mat(indexes_topM);
indexes_topS_v = cell2mat(indexes_topS);
indexes_topL_v = cell2mat(indexes_topL);

z_mean_indexes_topM = mean (indexes_topM_v);
z_var_indexes_topM = var(indexes_topM_v);
z_mean_indexes_topS = mean (indexes_topS_v);
z_var_indexes_topS = var(indexes_topS_v);
z_mean_indexes_topL = mean (indexes_topL_v);
z_var_indexes_topL = var(indexes_topL_v);


y_CIMedian_topMvstopS= estimateCIMedian(indexes_topM_v, indexes_topS_v, alph, iter);
y_CIMean_topMvstopS= estimateCIMean(indexes_topM_v, indexes_topS_v, alph, iter);

y_CIMedian_topMvstopL= estimateCIMedian(indexes_topM_v, indexes_topL_v, alph, iter);
y_CIMean_topMvstopL= estimateCIMean(indexes_topM_v, indexes_topL_v, alph, iter);

y_CIMedian_topSvstopL= estimateCIMedian(indexes_topS_v, indexes_topL_v, alph, iter);
y_CIMean_topSvstopL= estimateCIMean(indexes_topS_v, indexes_topL_v, alph, iter);


x_mean_indexes_topM = cellfun(@mean, indexes_topM);
x_mean_indexes_topS = cellfun(@mean, indexes_topS);
x_mean_indexes_topL = cellfun(@mean, indexes_topL);

x_var_indexes_topM = cellfun(@var, indexes_topM);
x_var_indexes_topS = cellfun(@var, indexes_topS);
x_var_indexes_topL = cellfun(@var, indexes_topL);

figure
histogram(indexes_topL_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top L']);

figure
histogram(indexes_topM_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top M']);

figure
histogram(indexes_topS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top S']);


tiledlayout(3,1)

nexttile
histogram(indexes_topL_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top L']);

nexttile
histogram(indexes_topM_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top M']);

nexttile
histogram(indexes_topS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top S']);
