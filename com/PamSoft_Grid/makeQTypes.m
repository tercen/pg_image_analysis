function qTypes = makeQTypes(oQ)
qNames = getquantitationtypenames;
r = getResult(oQ);


for j=1:length(r(:))
      for k=1:length(qNames)
          %keyboard
          %qNames{k}
          qTypes(j,k) = r(j).(qNames{k});
      end
end
