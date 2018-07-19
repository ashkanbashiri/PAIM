data=load('variances');
 f=fieldnames(data);
 for k=1:size(f,1)
   xlswrite('latest.xlsx',data.(f{k}),f{k})
 end