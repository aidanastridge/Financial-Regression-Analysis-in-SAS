
LIBNAME  Results "/folders/myfolders/sasuser.v94/Project/Results";

PROC IMPORT OUT= results.taiwanrealty
            DATAFILE= "/folders/myfolders/sasuser.v94/Project/Real estate valuation data set.xlsx" 
            DBMS=xlsx replace;
            sheet="Page 2";
            getnames=YES;
	 datarow=2;
RUN;

/*Descriptive*/
proc means data=results.taiwanrealty mean median var std min max range qrange;
var date age MRTDistance Latitude Longitude Value constores;
run;

/*TTest global property stat*/
proc ttest data=results.taiwanrealty h0=33.5 alpha=.05 sides=u;
var value;
where date =2013.500;
run;

/*Regression*/
proc reg data=results.taiwanrealty;
model value = date age MRTDistance Latitude Longitude constores/vif;
run;

proc reg data=results.taiwanrealty;
model value = date age MRTDistance  constores/slstay=0.05 slentry=0.05 selection=stepwise clm sse;
run;

proc reg data=results.taiwanrealty;
model value = date age MRTDistance Latitude Longitude constores/slstay=0.05 slentry=0.05 selection=backward clm sse;
run;

proc reg data=results.taiwanrealty;
model value = date age MRTDistance Latitude Longitude constores/slstay=0.05 slentry=0.05 selection=forward clm sse;
run;

/*Multicollinearity*/
proc corr data=results.taiwanrealty Pearson; 
     var value date age MRTDistance Latitude longitude constores;
run; 
/*Dummy Variables ConStores Baseline 0*/
data results.taiwanrealtyint2;
set results.taiwanrealty;
if Constores = 0 then do
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 1 then do
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 1;
end;

if Constores = 2 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 1;
One = 0;
end;

if Constores = 3 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 1;
Two = 0;
One = 0;
end;

if Constores = 4 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 1;
Three = 0;
Two = 0;
One = 0;
end;
if Constores = 5 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 1;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 6 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 1;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 7 then do 
Ten = 0;
Nine = 0;
Eight = 0;
Seven = 1;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 8 then do 
Ten = 0;
Nine = 0;
Eight = 1;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 9 then do 
Ten = 0;
Nine = 1;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

if Constores = 10 then do 
Ten = 1;
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
end;

ageo = one*age;
aget = two*age;
ageth = three*age;
agef = four*age;
agefi = five*age;
ages = six*age;
agese = seven*age;
agee = eight*age;
agen = nine*age;
agete=ten*age;

proc reg data=results.taiwanrealtyint2;
model value=date age MRTDistance Longitude Latitude One Two Three Four Five Six Seven Eight Nine ten ageo aget ageth agef agefi ages agese agee agen agete/dw slstay=0.05 slentry=0.05 selection=stepwise sse;
run;

proc reg data=results.taiwanrealtyint2;
model value=date age MRTDistance Longitude Latitude One Two Three Four Five Six Seven Eight Nine ten ageo aget ageth agef agefi ages agese agee agen agete/dw slstay=0.05 slentry=0.05 selection=forward sse;
run;

proc reg data=results.taiwanrealtyint2;
model value=date age MRTDistance Longitude Latitude One Two Three Four Five Six Seven Eight Nine ten ageo aget ageth agef agefi ages agese agee agen agete;
run;

proc reg data=results.taiwanrealtyint2;
model value=date age MRTDistance Longitude Latitude One Two Three Four Five Six Seven Eight Nine Ten/dw;
run;
/*Fit Plots for Longitude and Latitude*/
proc sgplot data=results.taiwanrealty;
reg y=value x=Longitude/ cli clm;
run;

proc corr data=results.taiwanrealtyint2 Pearson; 
     var value date age MRTDistance Longitude Latitude One Two Three Four Five Six Seven Eight Nine ten ageo aget ageth agef agefi ages agese agee agen agete;
run; 

proc sgplot data=results.taiwanrealty;
reg y=value x=Latitude/ cli clm;
run;

