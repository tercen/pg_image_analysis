function qTypes = makeQTypes(oQ)
[nRows, nCols] = size(oQ);
qNames = getquantitationtypenames;
r = getResult(oQ);
for j=1:length(r(:))
      for k=1:length(qNames)
        qTypes(j,k) = r(j).(qNames{k});
      end
end