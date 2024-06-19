% Leer los datos del archivo actual usando readmatrix
calibracionx = readmatrix('Top\ACC\calibracion_x.txt'); 
calibraciony = readmatrix('Top\ACC\calibracion_y.txt');
calibracionz = readmatrix('Top\ACC\calibracion_z.txt');

% Definir las columnas correspondientes a las posiciones en los archivos
columna_x = 3;
columna_y = 4;
columna_z = 5;

% Calcular máximos y mínimos para calibracionx
max_x_file1 = max(calibracionx(:, columna_x));
min_x_file1 = min(calibracionx(:, columna_x));
max_y_file1 = max(calibracionx(:, columna_y));
min_y_file1 = min(calibracionx(:, columna_y));
max_z_file1 = max(calibracionx(:, columna_z));
min_z_file1 = min(calibracionx(:, columna_z));
fprintf("Min calibración x %f, Max calibración x %f\n", min_x_file1, max_x_file1);

% Calcular máximos y mínimos para calibraciony
max_x_file2 = max(calibraciony(:, columna_x));
min_x_file2 = min(calibraciony(:, columna_x));
max_y_file2 = max(calibraciony(:, columna_y));
min_y_file2 = min(calibraciony(:, columna_y));
max_z_file2 = max(calibraciony(:, columna_z));
min_z_file2= min(calibraciony(:, columna_z));
fprintf("Min calibración y %f, Max calibración y %f\n", min_y_file2, max_y_file2);

% Calcular máximos y mínimos para calibracionz
max_x_file3 = max(calibracionz(:, columna_x));
min_x_file3 = min(calibracionz(:, columna_x));
max_y_file3 = max(calibracionz(:, columna_y));
min_y_file3 = min(calibracionz(:, columna_y));
max_z_file3 = max(calibracionz(:, columna_z));
min_z_file3 = min(calibracionz(:, columna_z));
fprintf("Min calibración z %f, Max calibración z %f\n", min_z_file3, max_z_file3);

% Calcular máximos y mínimos globales para cada posición
max_x_global = max([max_x_file1, max_x_file2, max_x_file3]);
min_x_global = min([min_x_file1, min_x_file2, min_x_file3]);
max_y_global = max([max_y_file1, max_y_file2, max_y_file3]);
min_y_global = min([min_y_file1, min_y_file2, min_y_file3]);
max_z_global = max([max_z_file1, max_z_file2, max_z_file3]);
min_z_global = min([min_z_file1, min_z_file2, min_z_file3]);
fprintf("Min calibración x global %f, Max calibración x global %f\n", min_x_global, max_x_global);
fprintf("Min calibración y global %f, Max calibración y global %f\n", min_y_global, max_y_global);
fprintf("Min calibración z global %f, Max calibración z global %f\n", min_z_global, max_z_global);