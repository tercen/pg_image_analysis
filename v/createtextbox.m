function createtextbox(figure1, clAnnotation)
%CREATETEXTBOX(FIGURE1)
%  FIGURE1:  annotation figure
 
%  Auto-generated by MATLAB on 24-Nov-2004 16:16:49
 
%% Create textbox
annotation1 = annotation(...
  figure1,'textbox',...
  'Position',[0.6758 0.1586 0.2419 0.6828],...
  'FitHeightToText','off', ...
  'String', char(clAnnotation)...
  );
 
