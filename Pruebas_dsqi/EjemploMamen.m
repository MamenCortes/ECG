%Toolboxes needed: Statistic and Machine Learning Toolbox, Signal Processing Toolbox; 

%Variables iniciales que definen los archivos txt y el tiempo que se tomará
%de muestra de los archivos. 
files = {'Camiseta\Prototipo_Day1_2024-02-01_11-20-02.txt', 'Camiseta\Prototipo_Day2_2024-02-07_09-59-58.txt'};
time = 1:(5*60)*1000; %tiempo en milisegundos = 5 minutos

%Importar los ficheros .txt; Se le pasa como argumento el nombre del
%archivo y el canal/ columna que se leerá
%La fución mSQI calcula los índices de calidad de señal
%Se repite el proceso con el resto de archivos. 
ecg1 =ImportPluxData(files{1}, 3); 
ecg1 = ecg1(time);
[kSQI_01_v,sSQI_01_v, pSQI_01_v, SQI_rel_powerLine_01_v,cSQI_01_v, basSQI_01_v,dSQI_01_v,geometricMean_V_19,averageGeometricMean_19] = mSQI(ecg1, 1000);
fprintf("Average mean of windows of %s: %f\n", files{1}, averageGeometricMean_19);
histogram(geometricMean_V_19, 20)

ecg2 = ImportPluxData(files{2}, 3);
ecg2 = ecg2(time);
[kSQI_01_v,sSQI_01_v, pSQI_01_v, SQI_rel_powerLine_01_v,cSQI_01_v, basSQI_01_v,dSQI_01_v,geometricMean_V_20,averageGeometricMean_20] = mSQI(ecg2, 1000);
fprintf("Average mean of windows of %s: %f\n", files{1}, averageGeometricMean_20);


%Representar las medias geométricas en histogramas. 
histogram(geometricMean_V_19, 20); 
figure
histogram(geometricMean_V_20, 20)


