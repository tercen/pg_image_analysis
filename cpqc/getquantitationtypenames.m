function qNames = getquantitationtypenames
%Select from the available result types 
%     Mean_Signal
%     Median_Signal
%     Std_Signal
%     Min_Signal
%     Max_Signal
%     Mean_Background
%     Median_Background
%     Std_Background
%     Min_Background
%     Max_Background
%     Signal_pValue
%     Signal_Saturation
%     Fraction_Ignored
%     Diameter
%     Shape_Factor
%     Aspect_Ratio
%     nChiSqr
%     X_Position
%     Y_Position
%     X_Offset
%     Y_Offset
%     Empty_Spot
%     Bad_Spot
%     Replaced_Spot

qNames =    {   'Mean_Signal', 'Median_Signal', 'Std_Signal', ...
                'Mean_Background', 'Median_Background', 'Std_Background', ...
                'Signal_pValue', 'Signal_Saturation', 'Fraction_Ignored', ...
                'Diameter', 'ShapeFactor', 'AspectRatio', 'X_Position','Y_Position', ...
                'X_Offset', 'Y_Offset'};
                
                
