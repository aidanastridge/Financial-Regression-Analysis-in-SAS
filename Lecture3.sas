/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~    ADMS 4375: Lecture 3      ~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/* To check licensed package list on installed SAS */
/* If you see '---SAS/ETS' then you are good to go */
proc setinit; run;


/* set the work directory - where your data is saved and where you want to save your SAS files.*/
LIBNAME mylib "/folders/myfolders/sasuser.v94/Time Series/L3/";

/* Import a comma delimited file (CSV) */
PROC IMPORT OUT= mylib.Retail
            DATAFILE="/folders/myfolders/sasuser.v94/Time Series/L3/Retail.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/* Import Data Alternative: File -> Import Data */
    
*ods rtf file="C:\Users\yawenx\Documents\YX\Teaching\ADMS4375\ADMS4375-2017\Lecture 03\Lec03.rtf" style=statistical;

/* Smoothed Series - MA  */
title 'Joint output plot for the Retail Data -- MA '; 
ods graphics on;
proc expand data=mylib.Retail  out= mylib.outMA3 plots=(jointoutput);
   convert Food_CA=BMA3/transformout=(movave 3) ;/*backward MA3*/
   convert Food_CA=CMA3/transformout=(cmovave 3);/*centered MA3*/
   convert Food_CA=FMA3/transformout=(reverse movave 3 reverse);/*forward MA3*/
   convert Food_CA=WMA3/transformout=(movave (0.2 0.3 0.5));/*weighted MA3*/
   run;


/*Revisit Retail data*/
title 'Joint output plot for the Retail Data -- MA(12) '; 
ods graphics on;
proc expand data=mylib.Retail out= mylib.outMA12 plots=(jointoutput);
   convert Food_CA=BMA12/transformout=(movave 12) ;/*backward MA12*/
   convert Food_CA=CMA12/transformout=(cmovave 12);/*centered MA12*/
   convert Food_CA=FMA12/transformout=(reverse movave 12 reverse);/*forward MA12*/
   convert Food_CA=WMA12/transformout=(movave (0.01 0.03 0.04 0.05 0.06 0.08 0.09 0.10 0.12 0.13 0.14 0.15));/*weighted MA12*/
run;
ods graphics off;

/* Smoothed Series - EWMA (Exponentially Weighted Moving Average) */
title 'Joint output plot for the Retail Data -- EWMA';
ods graphics on;
proc expand data=mylib.Retail out= mylib.outEWMA12 plots=(jointoutput);
   convert Food_CA=EWMA02/transformout=(ewma 0.2);
   convert Food_CA=EWMA08/transformout=(ewma 0.8);
run;
ods graphics off;

title 'forecasting sales using simple EWMA';
proc forecast data=mylib.Retail interval=month lead=5
               method=expo weight=0.2 trend=1 out=out1 outfull outest=est1;
               var food_ca;
			   id date;
run;
proc print data=est1; run;

title1 'Plot of Forecasts from Simple EWMA Method';
proc sgplot data=out1;
     series x=date y=food_CA /group=_type_ markers markerattrs=(symbol=circlefilled);
     xaxis values=('1jan04'd to '1Mar16'd by qtr);
     refline '1Oct15'd / axis=x;
run;

title 'forecasting sales using double EWMA';
proc forecast data=mylib.Retail interval=month lead=6 
               method=expo weight=0.2 trend=2 out=out2 outfull outest=est2;
               var food_ca;
			   id date;
run;
proc print data=est2; run;
title1 'Plot of Forecasts from Double EWMA Method';
proc sgplot data=out2;
     series x=date y=food_CA /group=_type_ markers markerattrs=(symbol=circlefilled);
     xaxis values=('1jan04'd to '1Apr16'd by qtr);
     refline '1Oct15'd / axis=x;
run;

title 'forecasting sales using triple EWMA';
proc forecast data=mylib.Retail interval=month lead=6
               method=expo weight=0.2 trend=3 out=out3 outfull outest=est3;
               var food_ca;
			   id date;
run;
proc print data=est3; run;

title1 'Plot of Forecasts from Triple EWMA Method';
proc sgplot data=out3;
     series x=date y=food_CA /group=_type_ markers markerattrs=(symbol=circlefilled);
     xaxis values=('1jan04'd to '1Apr16'd by qtr);
     refline '1Oct15'd / axis=x;
run;

title 'Taking into account of Seasonality';
proc forecast data=mylib.Retail interval=month lead=6
               method=Winters seasons=month trend=2 out=out4 outfull outest=est4;
               var food_ca;
			   id date;
run;
title1 'Plot of Forecasts from Winters Method';
proc sgplot data=out4;
     series x=date y=food_CA /group=_type_ markers markerattrs=(symbol=circlefilled);
     xaxis values=('1jan04'd to '1Apr16'd by qtr);
     refline '1Oct15'd / axis=x;
run;
proc print data=est4; run;

title 'Model Diag ESM Procedure -- Optimized Smoothing Weight in Exponential Smoothing';
ods graphics on;
proc esm data=mylib.Retail out=out5 outest=est5 lead=6 seasonality=12 plot=all;
     id date interval=month;
	 forecast food_CA/model=simple;
run;
ods graphics off;
proc print data=est5; run;

*ods rtf close;
proc esm data=mylib.Retail out=out5 outest=est5 lead=6 seasonality=12 plot=all;
     id date interval=month;
	 forecast food_CA/model=simple;
run;

proc esm data=mylib.Retail out=out5 outest=est5 lead=6 seasonality=12 plot=all;
     id date interval=month;
	 forecast food_CA/model=double;
run;

proc esm data=mylib.Retail out=out5 outest=est5 lead=6 seasonality=12 plot=all;
     id date interval=month;
	 forecast food_CA/model=linear;
run;

proc esm data=mylib.Retail out=out5 outest=est5 lead=6 seasonality=12 plot=all;
     id date interval=month;
	 forecast food_CA/model=winters;
run;









