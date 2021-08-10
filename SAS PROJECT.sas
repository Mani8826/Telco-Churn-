

                                     /*SAS PROJECT ON TELCO CHURN DATA*/
                                    /*Observations         71047     */
                                   /*Variables            58        */
     
                                                                      
            
                                
                            LIBNAME MS'C:\Users\simpl\Desktop\SAS PROJECT';

PROC IMPORT OUT= MS.TELECO_CHURN 
            DATAFILE= "C:\Users\simpl\Desktop\SAS PROJECT\Telco Churn Data (1).csv"
 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
     GUESSINGROWS=1000; 
RUN;
PROC SQL;
DESCRIBE TABLE MS.TELECO_CHURN;
QUIT;

PROC CONTENTS DATA = MS.TELECO_CHURN ;RUN;
PROC CONTENTS DATA = MS.TELECO_CHURN VARNUM SHORT;RUN;

PROC CONTENTS DATA=MS.SASPROJECT;
RUN;

PROC FREQ ;TABLE IncomeGroup CreditRating Occupation MaritalStatus MonthlyRevenue MonthlyMinutes DroppedCalls ServiceArea Handsets RetentionCalls  NewCellphoneUser NotNewCellphoneUser MadeCallToRetentionTeam PeakCallsInOut OffPeakCallsInOut TotalRecurringCharge DroppedBlockedCalls RespondsToMailOffers Churn;RUN;


*VARAIBLES SELECTIONS FOR STUDY FRAMEWORK/CONCEPTUAL FRAMWORK;
PROC SQL;
 CREATE TABLE MS.SASPROJECT AS
 SELECT CustomerID,
		Churn,
		IncomeGroup,
		CreditRating,
		Occupation,
		MaritalStatus,
		INPUT(MonthlyRevenue,BEST12.) AS MonthlyRevenue,
		INPUT(MonthlyMinutes,BEST12.) AS MonthlyMinutes,
		DroppedCalls ,
		ServiceArea ,
		Handsets,
		RetentionCalls,
        NewCellphoneUser,
		NotNewCellphoneUser,
		MadeCallToRetentionTeam,
		PeakCallsInOut,
		OffPeakCallsInOut,
		TotalRecurringCharge,
		DroppedBlockedCalls,
		RespondsToMailOffers
 FROM MS.TELECO_CHURN 
 WHERE CHURN NE "NA"
 ;
 QUIT;

*CREATE SAMPLE DATA FROM ORIGINAL DATA;
PROC SURVEYSELECT DATA = MS.TELECO_CHURN OUT=MS.SASPROJECT METHOD=SRS SAMPSIZE=10000  SEED = 987654321;
RUN;
* IDENTIYFIY NUMBER OF MISSING VALUES IN DATA;
Title "Identify number of missing values";
PROC MEANS DATA=MS.TELECO_CHURN
 MAXDEC=0 MISSING N NMISS;
 Run;
TITLE;

proc format;
 value $missfmt ' '='Missing' other='Not Missing';
 value  missfmt  . ='Missing' other='Not Missing';
run;
 
proc freq data=MS.TELECO_CHURN; 
format _CHAR_ $missfmt.; 
tables _CHAR_ / missing missprint nocum nopercent ;
format _NUMERIC_ missfmt.;
tables _NUMERIC_ / missing missprint nocum nopercent;
run;

 *FINDING MISSING VALUES;

TITLE 'Y VARAIBLE : CHURN';


*Y VARAIBLE : CHURN;
PROC FREQ DATA = MS.SASPROJECT ;
  TABLE CHURN/MISSING;
RUN;
TITLE;


* X VARAIBLES;
* Xs - CATEGORICAL VARAIBLES;

TITLE  'Xs - IncomeGroup';
PROC FREQ DATA =  MS.SASPROJECT ;
 TABLE IncomeGroup/MISSING;
RUN;
TITLE;

TITLE  'Xs - CreditRating Missing values';
PROC FREQ DATA = MS.SASPROJECT;
 TABLE CreditRating/MISSING;
RUN;
TITLE;


TITLE  'Xs - Occupation Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE Occupation/MISSING;
RUN;
TITLE;



TITLE  'Xs - MaritalStatus Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE MaritalStatus/MISSING;
RUN;
TITLE;

TITLE  'Xs - MonthlyRevenue Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE MonthlyRevenue/MISSING;
RUN;
TITLE;

TITLE  'Xs - MonthlyMinutes Missing values';
PROC FREQ DATA = MS.SASPROJECT;
 TABLE MonthlyMinutes/MISSING;
RUN;
TITLE;

TITLE  'Xs -DroppedCalls Missing values';
PROC FREQ DATA =  N_TELECO_CHURN;
 TABLE DroppedCalls/MISSING;
RUN;
TITLE;

TITLE  'Xs -ServiceAreas Missing values';
PROC FREQ DATA =  N_TELECO_CHURN;
 TABLE ServiceArea/MISSING;
RUN;
TITLE;


TITLE  'Xs -Handsets Missing values';
PROC FREQ DATA = MS.SASPROJECT;
 TABLE Handsets/MISSING;
RUN;
TITLE;


TITLE  'Xs - RetentionCalls Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE RetentionCalls/MISSING;
RUN;
TITLE;


TITLE  'Xs - NewCellphoneUser Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE NewCellphoneUser/MISSING;
RUN;
TITLE;

TITLE  'Xs - NotNewCellphoneUser Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE NotNewCellphoneUser/MISSING;
RUN;
TITLE;

TITLE  'Xs - MadeCallToRetentionTeam Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE MadeCallToRetentionTeam/MISSING;
RUN;
TITLE;


TITLE  'Xs -PeakCallsInOut Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE PeakCallsInOut/MISSING;
RUN;
TITLE;

TITLE  'Xs -OffPeakCallsInOut Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE OffPeakCallsInOut/MISSING;
RUN;
TITLE;

TITLE  'Xs -TotalRecurringCharge Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE OffPeakCallsInOut/MISSING;
RUN;
TITLE;

TITLE  'Xs -DroppedBlockedCalls Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE DroppedBlockedCalls/MISSING;
RUN;
TITLE;

TITLE  'Xs -RespondsToMailOffers Missing values';
PROC FREQ DATA =  MS.SASPROJECT;
 TABLE RespondsToMailOffers/MISSING;
RUN;
TITLE;

PROC CONTENTS DATA=MS.SASPROJECT;
RUN;

*Xs - Continuous varabiles;
PROC MEANS DATA =MS.SASPROJECT N NMISS MIN MEAN STD MAX RANGE;
 VAR MonthlyRevenue MonthlyMinutes;
RUN;

*TREATING MISSING VALUES;
PROC STDIZE DATA = MS.SASPROJECT OUT= MS.SASPROJECT_MEAN METHOD= MEAN MISSING = MEAN REPONLY;
 VAR MonthlyRevenue MonthlyMinutes Handsets;
RUN;


*CHECK IF THE MISSING VALUES HAVE BEEN REPLACED WITH MEAN OR NOT;
PROC MEANS DATA = MS.SASPROJECT_MEAN MAXDEC=2 N NMISS MIN MEAN STD MAX RANGE;
 VAR MonthlyRevenue MonthlyMinutes Handsets ;
RUN;

DATA MS.SASPROJECT_SER;
 SET MS.SASPROJECT;
IF ServiceAreas =' ' THEN ServiceAreas='HOUHOU281';
RUN;
PROC PRINT DATA=MS.SASPROJECT_SER;
RUN;

*OUTLIER DETECTION;
%MACRO OUTDETECTION(DATA= , VARNAME =);
PROC MEANS DATA = &DATA. MAXDEC=2 N P25 P75 QRANGE;
  VAR &VARNAME.  ;
OUTPUT OUT=MS.SASPROJECT_O P25= Q1 P75=Q3 QRANGE=IQR;
RUN;
data MS.TEMP_O;
SET MS.SASPROJECT;
 LOWER_LIMIT = Q1- (3*IQR);
  UPPER_LIMIT = Q3 +(3*IQR);
RUN;
PROC PRINT DATA= MS.TEMP_O;
RUN;
*CARTESIAN PRODUCT;
PROC SQL;
 CREATE TABLE MS.SASPROJECT_O1 AS
 SELECT A.*,B.LOWER_LIMIT,B.UPPER_LIMIT
 FROM &DATA. AS A ,MS.TEMP_O AS B
 ;
 QUIT;
 DATA MS.SASPROJECT_O2;
 SET MS.SASPROJECT_O1;
 IF &VARNAME. LE LOWER_LIMIT THEN INCOME_RANGE = "BELOW LOWER LIMIT";
 ELSE IF &VARNAME. GE UPPER_LIMIT THEN INCOME_RANGE = "ABOVE UPPER LIMIT";
 ELSE  &VARNAME._RANGE = "WITHIN RANGE";

PROC SQL;
 CREATE TABLE MS.SASPROJECT_O3 AS
 SELECT *
 FROM MS.SASPROJECT_O2
 WHERE INCOME_RANGE = "WITHIN RANGE";
QUIT;
PROC PRINT DATA = MS.SASPROJECT_O3;
 RUN;
%MEND OUTDETECTION;

%OUTDETECTION;



ODS PDF FILE = "C:\Users\simpl\Desktop\SAS PROJECT\.PDF";
PROC FREQ DATA = MS.SASPROJECT ;
  TITLE " FREQENCY DISTRIBUTION OF CHURN";
  TABLE MS.SASPROJECT;
RUN;
QUIT;

PROC GCHART DATA = MS.SASPROJECT ;
 TITLE "VERTICAL BAR CHART FOR CHURN DISTRIBUTION";
 VBAR3D Churn;
RUN;
QUIT;

PROC SGPLOT DATA = MS.SASPROJECT ;
 TITLE "VERTICAL BAR CHART FOR CHURN DISTRIBUTION";
 VBAR Churn;
RUN;
QUIT;


PROC GCHART DATA = MS.SASPROJECT ;
TITLE "PIE CHART FOR MaritalStatus DISTRIBUTION";
 PIE3D MaritalStatus;
RUN;
QUIT;

PROC GCHART DATA =  MS.SASPROJECT;
TITLE " DISTRIBUTION OF MonthlyRevenue";
 3D MonthlyRevenue;
RUN;
PROC SGPLOT DATA = AKM.PROJECT_VARS;
TITLE " DISTRIBUTION OF MonthlyRevenue";
 VBOX MonthlyRevenue;
RUN;

PROC UNIVARIATE DATA = AKM.PROJECT_VARS;
TITLE "COMPREHENISVE UNIVARAITE ANALYSIS OF MonthlyRevenue";
 VAR MonthlyRevenue;
RUN;
ODS PDF CLOSE;




##############################################################################################################################################







