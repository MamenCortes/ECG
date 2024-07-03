% Cargar el archivo CSV 'potencias_NombreArchivosOpenSignal.csv' y obtener solo la primera columna excluyendo el primer elemento
file_list_p = readcell('potencias_NombresArchivosOpenSignal.csv', 'Delimiter', ',');
% Extraer todos los elementos excepto el primero
potencias_archivos_generados = file_list_p(2:end); %Contiene una columna con los nombre de todos los archivos

geometricMeans_v = readmatrix('mSQI_geometricMean.csv'); 
length_geometricMeans_v = length(geometricMeans_v(1, :));
num_columns = length(geometricMeans_v(1, :));
num_rows = length(geometricMeans_v(:, 1));
corr_mSQI_X = [0,num_columns];
corr_mSQI_Y = [0,num_columns];
corr_mSQI_Z = [0,num_columns];
corr_mSQI_XYZ = [0,num_columns];

for i = 1:num_columns
    data_potencias = readmatrix(potencias_archivos_generados{i});
    resultados_geometricMean_vector = geometricMeans_v(:, i);

    %correlations
    corr_mSQI_X(i) = corr(resultados_geometricMean_vector, data_potencias(1:num_rows, 1));
    corr_mSQI_Y(i) = corr(resultados_geometricMean_vector, data_potencias(1:num_rows, 2));
    corr_mSQI_Z(i) = corr(resultados_geometricMean_vector, data_potencias(1:num_rows, 3));
    corr_mSQI_XYZ(i) = corr(resultados_geometricMean_vector, data_potencias(1:num_rows, 4)); 
    
end

T = table('Size', [length(corr_mSQI_X) 4], 'VariableTypes', {'double', 'double', 'double', 'double'}, 'VariableNames', {'corr_X', 'corr_Y', 'corr_Z', 'corr_XYZ'});
T.corr_X = corr_mSQI_X';
T.corr_Y = corr_mSQI_Y';
T.corr_Z = corr_mSQI_Z';
T.corr_XYZ = corr_mSQI_XYZ';

%disp(T); 
writetable(T, "correlation_powerANDmSQI.csv"); 
