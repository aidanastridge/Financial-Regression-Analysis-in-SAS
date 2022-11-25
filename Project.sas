
LIBNAME  Results "/folders/myfolders/sasuser.v94/Project/Results";

PROC IMPORT OUT= results.taiwanrealty
            DATAFILE= "/folders/myfolders/sasuser.v94/Project/Real estate valuation data set.xlsx" 
            DBMS=xlsx replace;
            sheet="Page 2";
            getnames=YES;
	 datarow=2;
RUN;

/*Qunatitative*/
proc means data=results.taiwanrealty mean median var std min max range qrange;
var date age MRTDistance Latitude Longitude Value constores;
run;


proc univariate data=results.taiwanrealty plot;
var value;
class Quarter;
run;

proc sort data=results.taiwanrealty out=results.taiwanrealty; by MonthN; run;

proc boxplot data=results.taiwanrealty;
plot value*MonthN/notches;
run;

/*Lon by Lat by Value*/
proc sgplot data=results.taiwanrealty;
scatter x=latitude y=longitude/ colorresponse=value colormodel=(cx6497EB cxF3F7FE cxFF0000)  markerattrs=(symbol=CircleFilled size=8);
run;

/*ANOVA Value by constores*/
proc anova data=results.taiwanrealty;
class constores;
model value=constores;
run;

/*TTest global property stat*/
proc ttest data=results.taiwanrealty h0=33.5 alpha=.05 sides=u;
var value;
where date =2013.500;
run;

/*95% CI Age by MRT Distance*/
proc sgplot data=results.taiwanrealty;
scatter x=age y=MrtDistance/markerattrs=(symbol=CircleFilled size=8);
ellipse x=age y=mrtdistance/lineattrs=(color=cxFF0000);
yaxis values=(0 to 7000 by 1000)
              grid offsetmin=.05 offsetmax=.05;
run;

/*Regression*/
proc reg data=results.taiwanrealty;
model value = date age MRTDistance Latitude Longitude constores;
run;

proc reg data=results.taiwanrealty;
model value = date age MRTDistance Latitude Longitude constores/slstay=0.05 slentry=0.05 selection=stepwise clm sse;
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
 
/*Dummy Variables Age Categories 1= 0 to 10 etc. (I dont like this regression becuase its kind of a biased estimator)*/
data results.taiwanrealtyagec;
set results.taiwanrealty;
if Age_Categories = 1 then do Zero = 1;
Ten = 0;
Twenty = 0;
Thirty = 0;
end;
if Age_Categories = 2
then do Zero = 0;
Ten = 1;
Twenty = 0;
Thirty = 0;
end;
if Age_Categories = 3
then do Zero = 0;
Ten = 0;
Twenty = 1;
Thirty = 0;
end;
if Age_Categories = 4
then do Zero = 0;
Ten = 0;
Twenty = 0;
Thirty = 1;
end;
if Age_Categories = 5
then do Zero = 0;
Ten = 0;
Twenty = 0;
Thirty = 0;
end;

mrtdz= MRTDistance*Zero;
mrtdt= MRTDistance*Ten;
mrtdtt= MRTDistance*Twenty;
mrtdttt= MRTDistance*Thirty;
;

proc reg data=results.taiwanrealtyagec;
model value = date Zero Ten Twenty Thirty MRTDistance Latitude longitude constores;
run;

/*Dummy Variables ConStores*/
data results.taiwanrealtyint;
set results.taiwanrealty;
if Constores = 0 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 1;
end;
if Constores = 1 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 1;
Zero = 0;
end;
if Constores = 2 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 1;
One = 0;
Zero = 0;
end;
if Constores = 3 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 1;
Two = 0;
One = 0;
Zero = 0;
end;
if Constores = 4 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 1;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;
if Constores = 5 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 1;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;
if Constores = 6 then do Nine = 0;
Eight = 0;
Seven = 0;
Six = 1;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;
if Constores = 7 then do Nine = 0;
Eight = 0;
Seven = 1;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;
if Constores = 8 then do 
Nine = 0;
Eight = 1;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;

if Constores = 9 then do 
Nine = 1;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;

if Constores = 10 then do 
Nine = 0;
Eight = 0;
Seven = 0;
Six = 0;
Five = 0;
Four = 0;
Three = 0;
Two = 0;
One = 0;
Zero = 0;
end;

latz = zero*latitude;
lato = one*latitude;
latt = two*latitude;
latth = three*latitude;
latf = four*latitude;
latfi = five*latitude;
lats = six*latitude;
latse = seven*latitude;
late = eight*latitude;
latn = nine*latitude;

lonz = Zero*longitude;
lono = one*longitude;
lont = two*longitude;
lonth = three*longitude;
lonf = four*longitude;
lonfi = five*longitude;
lons = six*longitude;
lonse = seven*longitude;
lone = eight*longitude;
lonn = nine*longitude;

ageo = one*age;
aget = two*age;
ageth = three*age;
agef = four*age;
agefi = five*age;
ages = six*age;
agese = seven*age;
agee = eight*age;
agen = nine*age;

lonlat = longitude*latitude;

/*Interaction lonlat ConStores*/
proc reg data=results.taiwanrealtyint;
model value=date age MRTDistance Longitude Latitude Zero One Two Three Four Five Six Seven Eight Nine;
run;

proc reg data=results.taiwanrealtyint;
model value=date age MRTDistance Longitude Latitude latz lato latt latth latf latfi lats latse late latn lonz lono lont lonth lonf lonfi lons lonse lone lonn Zero One Two Three Four Five Six Seven Eight Nine/slstay=0.05 slentry=0.05 selection=stepwise sse;
run;

proc reg data=results.taiwanrealtyint;
model value=date age MRTDistance Longitude Latitude latz lato latt latth latf latfi lats latse late latn lonz lono lont lonth lonf lonfi lons lonse lone lonn Zero One Two Three Four Five Six Seven Eight Nine;
run;


/*Interaction Age ConStores*/
proc reg data=results.taiwanrealtyint;
model value=date age MRTDistance Longitude Latitude Zero One Two Three Four Five Six Seven Eight Nine ageo aget ageth agef agefi ages agese agee agen/slstay=0.05 slentry=0.05 selection=stepwise sse;
run;


proc reg data=results.taiwanrealtyint;
model value=date age MRTDistance Longitude Latitude Zero One Two Three Four Five Six Seven Eight Nine ageo aget ageth agef agefi ages agese agee agen;
run;

