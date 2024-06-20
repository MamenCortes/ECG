% Cargar el archivo CSV 'potencias_NombreArchivosOpenSignal.csv' y obtener solo la primera columna excluyendo el primer elemento
file_list_p = readcell('potencias_NombresArchivosOpenSignal.csv', 'Delimiter', ',');
% Extraer todos los elementos excepto el primero
potencias_archivos_generados = file_list_p(2:end);

file_list_msqi = readcell('mSQI_NombresArchivos_OpenSignal', 'Delimiter', ',');
% Extraer todos los elementos excepto el primero
mSQI_archivos_generados = file_list_msqi(2:end);

% Loop sobre cada par de archivos (potencias y vector geométrico)
for i = 1:numel(potencias_archivos_generados)
    file_name_power = potencias_archivos_generados{i};
    file_name_geomVector = mSQI_archivos_generados{i};
    
    % Leer los datos del archivo de potencia actual
    data_potencias = readmatrix(file_name_power);

    % Remove the last element from each column -> error de dim
    resultados_potenciax = data_potencias(1:end-1, 1); 
    resultados_potenciay = data_potencias(1:end-1, 2); 
    resultados_potenciaz = data_potencias(1:end-1, 3); 
    resultados_potenciaxyz = data_potencias(1:end-1, 4);

    % Leer los datos del archivo de vector geométrico actual
    data_geomVector = readmatrix(file_name_geomVector);
    resultados_geometricMean_vector = data_geomVector(:, 1);

    % Calculate correlations
    corr_mSQI_px = corr(resultados_geometricMean_vector, resultados_potenciax);
    corr_mSQI_py = corr(resultados_geometricMean_vector, resultados_potenciay);
    corr_mSQI_pz = corr(resultados_geometricMean_vector, resultados_potenciaz);
    corr_mSQI_pxyz = corr(resultados_geometricMean_vector, resultados_potenciaxyz);

    % Guardar las correlaciones
    correlations = [corr_mSQI_px; corr_mSQI_py; corr_mSQI_pz; corr_mSQI_pxyz];

    % Definir los nombres de las correlaciones
    columnas = {'corr_mSQI_px', 'corr_mSQI_py', 'corr_mSQI_pz', 'corr_mSQI_pxyz'};

    % Crear la tabla
    tabla_resultados = table(corr_mSQI_px, corr_mSQI_py, corr_mSQI_pz, corr_mSQI_pxyz, 'VariableNames', columnas);

    % Definir el nombre del archivo CSV de salida
    nombre_archivo = ['CorrelacionesOpenSignal.csv_' file_name_power(1:end-4) '_' file_name_geomVector(1:end-4)];

    % Escribir la tabla en el archivo CSV
    writetable(tabla_resultados, nombre_archivo);
end