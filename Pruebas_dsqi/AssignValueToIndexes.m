%assign a value between 0.1-1 to each of the indexes and calculate the
%geometric mean
function [kSQI_index01,sSQI_index01, pSQI_index01, cSQI_index01, basSQI_index01, gmean ] = AssignValueToIndexes(kSQI,sSQI, pSQI, cSQI, basSQI)
   y = [lowerLimit 1]; %vector para interpolation
   %for kSQI
   x_k = [2.5 6];
   if kSQI<=2.5
     kSQI_index01 = lowerLimit;
   elseif(kSQI>5)
      kSQI_index01 =1;
   else
    kSQI_index01 = interp1(x_k,y,kSQI);
   end

   %for sSQI
   x_s = [0.4 3];
   if sSQI<0.5
       sSQI_index01 = lowerLimit;
   elseif sSQI>2
       sSQI_index01 = 1;
   else
       sSQI_index01 = interp1(x_s,y,sSQI);
   end

   %for pSQI
   x_p = [0.9 0.5];
   if pSQI>=0.9
       pSQI_index01 = lowerLimit;
   elseif pSQI>= 0.5 || pSQI< 0.8
       pSQI_index01 = 1;
   else
       pSQI_index01 = interp1(x_p,y,pSQI);
   end

   %for cSQI
   x_c = [0.66 0.5];
   if cSQI> 0.65
       cSQI_index01 = lowerLimit;
   elseif cSQI<0.45
       cSQI_index01 = 1;
   else
       cSQI_index01 = interp1(x_c,y,cSQI);
   end

   %for basSQI
   x_b = [0.7 0.97];
   if basSQI<0.85
       basSQI_index01 = lowerLimit;
   elseif basSQI>0.95
       basSQI_index01 = 1;
   else
       basSQI_index01 = interp1(x_b,y,basSQI);
   end

   %calculate the geometric mean between the indexes 
   index_product = kSQI_index01*cSQI_index01*pSQI_index01*cSQI_index01*basSQI_index01;
   gmean = (index_product)^(1/5);
end

function lower_limit = lowerLimit  %usamos de momento 0.1 como valor mínimo para los índices
    lower_limit = 0.1;
end 