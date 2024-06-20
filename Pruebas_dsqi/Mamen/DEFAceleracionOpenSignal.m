% Frecuencia de muestreo original
frecuencia_original = 1000;  % Hz

% Número de muestras por ventana de 10 segundos
muestras_por_ventana = round(frecuencia_original * 10); % 10000 samples

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
    data = readmatrix(file_path);  % Suponiendo que los datos están en formato adecuado para la carga
    
    % Extraer las columnas correspondientes a las posiciones x, y, z
    posicion_x = data(:, 4);
    posicion_y = data(:, 5);
    posicion_z = data(:, 6);

    % CALIBRACIONES -> caluladas en el archivo Calibraciones
    min_x = 27464;
    min_y = 27012;
    min_z = 32484;

    max_x = 37856;
    max_y = 37802;
    max_z = 44508;

    aceleracion_x =  2*(posicion_x-min_x)/(max_x-min_x) -1;
    aceleracion_y =  2*(posicion_y-min_y)/(max_y-min_y) -1;
    aceleracion_z =  2*(posicion_z-min_z)/(max_z-min_z) -1;

    % Calcular las velocidades a partir de las posiciones (primera derivada)
    %velocidad_x = diff(posicion_x);
    %velocidad_y = diff(posicion_y);
    %velocidad_z = diff(posicion_z);

    % Asumir un intervalo de tiempo constante (s)
    %intervalo_tiempo = mean(diff(data(:, 1)));  

    % Calcular las aceleraciones a partir de las velocidades (segunda derivada)
    %aceleracion_x = diff(velocidad_x) / intervalo_tiempo;
    %aceleracion_y = diff(velocidad_y) / intervalo_tiempo;
    %aceleracion_z = diff(velocidad_z) / intervalo_tiempo;

    % Inicializar variables para el filtro paso bajo
    g_x = 0;
    g_y = 0;
    g_z = 0;

    % Aplicar el filtro paso bajo a las lecturas del acelerómetro
    for i = 1:length(aceleracion_x)
        % Aplicar filtro paso bajo a la componente x
        g_x = 0.9 * g_x + 0.1 * aceleracion_x(i);
        aceleracion_x(i) = aceleracion_x(i) - g_x;

        % Aplicar filtro paso bajo a la componente y
        g_y = 0.9 * g_y + 0.1 * aceleracion_y(i);
        aceleracion_y(i) = aceleracion_y(i) - g_y;

        % Aplicar filtro paso bajo a la componente z
        g_z = 0.9 * g_z + 0.1 * aceleracion_z(i);
        aceleracion_z(i) = aceleracion_z(i) - g_z;
    end

    % Inicializar matrices para almacenar los resultados
    resultados = zeros(floor(length(aceleracion_x)/muestras_por_ventana), 4);

    % Calcular la potencia total para cada ventana de 10 segundos
    indice_resultados = 1;
    for i = 1 : muestras_por_ventana : length(aceleracion_x)
        ventana_x = aceleracion_x(i : min(i + muestras_por_ventana - 1, length(aceleracion_x)));
        ventana_y = aceleracion_y(i : min(i + muestras_por_ventana - 1, length(aceleracion_y)));
        ventana_z = aceleracion_z(i : min(i + muestras_por_ventana - 1, length(aceleracion_z)));

        potencia_x = mean(ventana_x.^2);
        potencia_y = mean(ventana_y.^2);
        potencia_z = mean(ventana_z.^2);

        potencia_total_xyz= potencia_x + potencia_y + potencia_z;

        % Guardar resultados en la matriz 
        resultados(indice_resultados, :) = [potencia_x, potencia_y, potencia_z, potencia_total_xyz];

        % Incrementar el índice de resultados
        indice_resultados = indice_resultados + 1;
    end

    % Nombre del archivo CSV de salida
    nombre_archivo = ['PotenciasOpenSignal_', file_name, '.csv'];

    % Crear una tabla con nombres de columnas
    columnas = {'potencia_x', 'potencia_y', 'potencia_z', 'potencia_total_xyz'};
    tabla_resultados = array2table(resultados, 'VariableNames', columnas);

    % Escribir en el archivo CSV
    writetable(tabla_resultados, nombre_archivo);

    % Agregar el nombre del archivo generado al array + create file, para usar en el calculo msqi
    potencias_archivos_generados{file_index} = nombre_archivo;

end

file_list = cell2table(potencias_archivos_generados', 'VariableNames', {'NombreArchivo'});
csv_filename = 'potencias_NombresArchivosOpenSignal.csv';
writetable(file_list, csv_filename);