
%calculate the index for windows of 4 seconds
function [kSQI_01_vector,sSQI_01_vector, pSQI_01_vector, cSQI_01_vector, basSQI_01_vector,dSQI_01_vector,gmean_vector] = IndexForSignalWindows(ECG)
      ecg = importdata(ECG);
      ecg_values = ecg.data;
      data = ecg_values(:,3);
      
      FS_original = originalFS;
      Fs_new = samplingFreq;
      [P,Q] = rat(Fs_new/FS_original);
      data_s = resample(data,P,Q);
      %plot(data_s);

      len = length(data_s);
      window_len = windowSize*Fs_new;
      size_vector = round((len/window_len));
      kSQI_01_vector =zeros(1,size_vector);
      sSQI_01_vector= zeros(1,size_vector);
      pSQI_01_vector = zeros(1,size_vector);
      cSQI_01_vector = zeros(1,size_vector);
      basSQI_01_vector = zeros(1,size_vector);
      dSQI_01_vector = zeros(1,size_vector);
      gmean_vector = zeros(1,size_vector);

      [qrs,varargout] = pantompkins_qrs(data_s,samplingFreq,logical(0)); 

      for i=1:(((round(len/window_len))-1))
          
         data_f=data_s((i-1)*(window_len)+1:i*(window_len)+1);
         qrs_window = qrs(i:i+windowSize); 
         %calculamos los índices y le asignamos un valor entreo 0.1 y 1.
         %También la media geométrica 
         [kSQI,sSQI, pSQI, cSQI,basSQI] = IndexCalculation(data_f,qrs_window);
         [total_dSQI, cont_dSQI, s_dSQI] = dsqi(data_f, samplingFreq);
         [kSQI_01,sSQI_01, pSQI_01, cSQI_01, basSQI_01,dSQI_01,gmean] = AssignValueToIndexes(kSQI,sSQI, pSQI, cSQI,basSQI,total_dSQI);

         %metemos el valor en cada uno de los vectores 
         kSQI_01_vector(i) = kSQI_01; 
         kurtosis_vector_ups = upsampleVector(kSQI_01_vector);
         sSQI_01_vector(i) = sSQI_01;
         skewness_vector_ups = upsampleVector(sSQI_01_vector);
         pSQI_01_vector(i) = pSQI_01;
         power_vector_ups = upsampleVector(pSQI_01_vector);
         cSQI_01_vector(i) = cSQI_01;
         var_vector_ups = upsampleVector(cSQI_01_vector);
         basSQI_01_vector(i) = basSQI_01;
         bas_vector_ups = upsampleVector( basSQI_01_vector);
         gmean_vector(i) = gmean;
         dSQI_01_vector(i)=dSQI_01;
      end
          showAllPlots = showPlots;
          if(showAllPlots == 1)
          plot(data_s);
          hold on;
          plot(kurtosis_vector_ups*(50000/mean(kSQI_01_vector))); %upsampling del vector y multiplicar 
          title("ECG+Kurtosis");

          figure
          plot(data_s);
          hold on;
          plot(skewness_vector_ups*(50000/mean(sSQI_01_vector)));
          title("ECG+Skewness");

          figure
          plot(data_s);
          hold on;
          plot(power_vector_ups*(50000/mean(pSQI_01_vector)))
          title("ECG+Power");

          figure
          plot(data_s);
          hold on;
          plot(var_vector_ups*(50000/mean(cSQI_01_vector)));
          title("ECG+R-RVariability");

          figure
          plot(data_s);
          hold on;
          plot(bas_vector_ups*(50000/mean(basSQI_01_vector)));
          title("ECG+BaseLine");
          end

end

function [vector_ups] = upsampleVector(vector)
    Fs = 1/windowSize;
    Fs_ecg = samplingFreq;
    [P1,Q1] = rat(Fs_ecg/Fs);
    vector_ups = resample(vector,P1,Q1);

end