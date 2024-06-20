% Nombres de los archivos de prueba:
file1 = 'Top\S\S_DIA1_2024-05-17_09-57-48.txt';
file2 = 'Top\S\S_DIA2_2024-05-22_07-30-33.txt';
file3 = 'Top\S\S_DIA3_2024-05-25_09-31-38.txt';
file4 = 'Top\S\S_DIA4_2024-06-03_09-38-01.txt';

file5 = 'Top\M\M_DIA1_2024-05-14_07-45-49.txt';
file6 = 'Top\M\M_DIA2_2024-05-21_08-17-33.txt';
file7 = 'Top\M\M_DIA3_2024-05-24_09-58-13.txt';
file8 = 'Top\M\M_DIA4_2024-06-02_09-08-18.txt';

file9  = 'Top\L\L_DIA1_2024-05-16_10-03-55.txt';
file10 = 'Top\L\L_DIA2_2024-05-20_09-58-30.txt';
file11 = 'Top\L\L_DIA3_2024-05-30_10-29-44.txt';
file12 = 'Top\L\L_DIA4_2024-06-07_12-49-23.txt';

files_pruebaCortas_OpenSignal = {file1, file2, file3, file4, file5, file6, file7, file8, file9, file10, file11, file12};
file_names = {'S_DIA1', 'S_DIA2', 'S_DIA3', 'S_DIA4', 'M_DIA1', 'M_DIA2', 'M_DIA3', 'M_DIA4', 'L_DIA1', 'L_DIA2', 'L_DIA3', 'L_DIA4'};
% Loop sobre cada archivo
for file_index = 1:numel(files_pruebaCortas_OpenSignal)
    file_path = files_pruebaCortas_OpenSignal{file_index};
    file_name = file_names{file_index}; 
    
    % Leer los datos del archivo actual usando readmatrix
    data = readmatrix(file_path);

    ecg_opensignal = data(:, 3);% opensignal
    
    n = length(ecg_opensignal);
    indexes_escaleras = cell(1,n);

    [kSQI_01_vector,sSQI_01_vector, pSQI_01_vector,rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector,dSQI_01_vector,geometricMean_vector,averageGeometricMean] = mSQI(ecg_opensignal, 1000)

    % Escribir el geometricMean_vector en un archivo de texto -> la usare luego para calcular la correlacion
    % Convertir el vector en una tabla con el nombre de columna deseado
    %aplico la traspuesta -> geometricMean_vector', para q el archivo tenga
    %geometricMean_vector en formato columna
    geometricMean_table = table(geometricMean_vector', 'VariableNames', {'geometricMean_vector'});
    
    % Nombre del archivo CSV de salida
    nombre_archivo = ['mSQI_OpenSignal_', file_name, '.csv'];
    
    % Escribir la tabla en el archivo CSV
    writetable(geometricMean_table, nombre_archivo);
    
     % Guardar el nombre del archivo en el array
        mSQI_archivos_generados{file_index} = nombre_archivo;
end

% Guardar el array de nombres de archivos generados
%save('mSQI_archivos.mat', 'mSQI_archivos_generados');

file_list = cell2table(mSQI_archivos_generados', 'VariableNames', {'NombreArchivo'});
csv_filename = 'mSQI_NombresArchivos_OpenSignal.csv';
writetable(file_list, csv_filename);