// Final Do File
// Replication of "The Value of U.S. College Education in Chinese Labor Markets"
// Dataset: "The Value of U.S. College Education in Chinese Labor Markets" - Edited

clear all                      
set more off                    
capture log close               

cd  "/Users/mihir/Documents/D Drive/Mihir Docs UMD/Sem 2/644/Project/replication_package_MS-DEC-20-02873/FInal Files" // Working directory

// TO USE THIS DO FILE, Keep both the datasets in the same directory.

// Dataset1: Final_Data
// Dataset2: Rankings

log using FinalDoFile.log, replace					// Logging the code

ssc install schemepack, replace 					// Setting the scemepack
ssc install coefplot, replace 					// For plotting regression coefficients

set scheme white_tableau, perm

*********************************************************************************
* 						CLEANING AND ORGANIZING THE DATA
*********************************************************************************

// This section of the code has been commented out because the final clean //
// dataset has been provided with the project. This section includes the //
// code used to transform the original dataset to the final dataset.//

*********************************************************************************

// use full_final.dta, replace							// Loading the data
//
// sum                                                 // Summarize the variables in the dataset
// codebook, compact                                  // Generate codebook information, compact format
// drop if city == "GZ" 							// Focusing on Beijing and Shanghai, dropping GZ
//
// // With the basid summary check done, we can clean and modify the dataset 
// // for better understanding
//
// // Adding variable labels
//
// label variable job_id "Unique Job Identifier"
// label variable city "City of the job"
// label variable sector "Sector of the job"
// label variable business "If the job is for Business Major"
// label variable lmarket "Labor market of the job"
// label variable us "School listed on job application is an US school"
// label variable exp "Experience type of the job applicant"
// label variable female "Applicant is a female"
// label variable name "Unique name identifier"
// label variable se "Unique identifier for self evaluations"
// label variable ed_country "Country of the school"
// label variable wage_mid "Posted wage midpoint"
// label variable wage_mid_d "Posted wage midpoint in USD"
// label variable wave "Wave id - Fall or Spring"
// label variable callback "Whether the application received a callback"
// label variable interview "Whether the application received a callback to request for an interview"
// label variable vs "School is in the Very Selective group"
// label variable selective "School is in the Selective group"
// label variable inclusive "School is in the inclusive group"
// label variable range "School's average test score percentile"
//
// // Encoding the name, selectivity and lmarket
//
// encode name, gen(name_c)					// Encoding variables 
// encode se, gen(se_c)
// encode lmarket, gen(lmarket_c)
// encode city, gen(city_c)
//
// gen wave2 = 0								// Creating a binary variable for Wave2
// replace wave2 = 1 if wave == 2
//
//
// *********************************************************************************
// * 							ADDING VALUES FOR ANALYSIS
// *********************************************************************************
//
// // Creating a standardized variable for wage comparison in USD
//
// gen wage_d=wage_mid_d/1000
//
// // For the purpose of the study, we are testing the wage in quartiles. The models 
// // we use are linear probability, logit and probit, therefore, we will generate 
// // the required binary variables for regression 
//
// // Creating binary variables for wage in percentiles
//
// centile wage_mid, centile(10 20 30 40 50 60 70 80 90)
// return list 
// gen pay10 = 0
// replace pay10 = 1 if wage_mid < r(c_1) 
// gen pay1020 = 0
// replace pay1020 = 1 if wage_mid >= r(c_1) & wage_mid < r(c_2)
// gen pay2030 = 0
// replace pay2030 = 1 if wage_mid >= r(c_2) & wage_mid < r(c_3)
// gen pay3040 = 0
// replace pay3040 = 1 if wage_mid >= r(c_3) & wage_mid < r(c_4) 
// gen pay4050 = 0
// replace pay4050 = 1 if wage_mid >= r(c_4) & wage_mid < r(c_5) 
// gen pay5060 = 0
// replace pay5060 = 1 if wage_mid >= r(c_5) & wage_mid < r(c_6) 
// gen pay6070 = 0
// replace pay6070 = 1 if wage_mid >= r(c_6) & wage_mid < r(c_7) 
// gen pay7080 = 0
// replace pay7080 = 1 if wage_mid >= r(c_7) & wage_mid < r(c_8) 
// gen pay8090 = 0
// replace pay8090 = 1 if wage_mid >= r(c_8) & wage_mid < r(c_9) 
// gen pay90 = 0
// replace pay90 = 1 if wage_mid >= r(c_9)
//
//
// // We want to analyse the impact of an education from the US on opportunities 
// // China. For this we will need to create variables that represent the choice of 
// // the individual to stay in the us, leave or otherwise. And then another variable 
// // to match that choice to the selectivity of their institution
//
//
// // Creating binary variables for candidates decision, work experience and 
// // univeristy. 
//
// // The program 'inter' will take the given variable value and multiply it by
// // the binar values in 'us', 'vs', 'selective'. 
// // Eg: if usstayedus = 1, the person stayed in the US AND has School listed on 
// // job application is an US school, similarly for the other variables
// // This allows us to create multiple interaction terms for future use
//
// program define inter
// gen us`1'=us*`1'
// gen vs`1'=vs*`1'
// gen s`1'=selective*`1'
// set matsize 800
// end
//
// inter wage_d
// inter wage_mid
//
// drop hs req_en wh_type2 ctype ctype_cn test cdgrad
//
//
// xtset job_id 								// Setting up the panel dataset
//
// save Final_Data.dta, replace

*********************************************************************************
* 								DESCRIPTIVE STATISTICS
*********************************************************************************

clear 

use Final_Data.dta, replace

sum                                                 // Summarize the variables in the dataset
codebook, compact                                  // Generate codebook information, compact format

// Reviewing the descriptive statistics of the focus variables

// For this study, the variable of interest is going to be "callback". We will 
// run all the regression models with varying charecteristics but the primary 
// variable of interest will be limited to "callback"

sum callback, detail							// Descriptive stats for callback

// For the descriptive statistics, we are only seeing for the core data that 
// was collected by the author. We are not seeing for the variables that we 
// have created for our regression tables

// The descriptive stats for the core Explanatory Variables are follows

sum us									// Explanatory variable
sum business							// Explanatory variable
sum city								// Explanatory variable
sum female								// Explanatory variable
sum exp									// Explanatory variable
sum wage_d								// Explanatory variable

sum callback, d

sum callback if vs == 1
sum callback if selective == 1
sum callback if inclusive == 1

sum callback if us == 1
sum callback if us == 0

sum callback if business == 1
sum callback if business == 0

sum callback if female == 1
sum callback if female == 0

sum callback if wave == 1
sum callback if wave2 == 1



// Graphically reviewing the descriptive statistics of the focus variables


// Graphing the callbacks recevied
histogram callback, fraction barwidth(0.15) ylab(0(0.20)1.00) ///
	xlabel(-.5 " " 0 "0" 0.5 " " 1 "1" 1.5 " ") xtitle("Callback (1 = Yes & 0 = No)") ///
	ytitle("Percentage of Callbacks") title("Callbacks Received By Applications", size(medsmall)) ///
	note("Data: Chen(2024)") name(fig1, replace)

// Graphing the country distribution
histogram us, fraction barwidth(0.15) ylab(0(0.20)1.00) ///
	xlabel(-.5 " " 0 "0" 0.5 " " 1 "1" 1.5 " ") ///
	xtitle("Country Of Education (1 = US & 0 = China)") ///
	ytitle("Fraction") title("Distribution Of Applications By School Country", size(medsmall)) ///
	note("Data: Chen(2024)") name(fig2, replace)

// Graphing the distribution of Business vs Computer Science graduates
histogram business, fraction barwidth(0.15) ylab(0(0.20)1.00) ///
	xlabel(-.5 " " 0 "0" 0.5 " " 1 "1" 1.5 " ") ///
	xtitle("Undergraduate Degree (1 = Business & 0 = Computer Science)") ///
	ytitle("Fraction") title("Distribution Of Students By Major", size(medsmall)) ///
	note("Data: Chen(2024)") name(fig3, replace)

// Graphing the distribution of the City of the Job
histogram city_c, fraction barwidth(0.15) ylab(0(0.20)1.00) ///
	xlabel(0 " " 1 "Beijing" 2 "Shanghai" 2.5 " ") ///
	xtitle("City Of Job Posting") ///
	ytitle("Fraction") title("Distribution Of Job Postings By City", size(medsmall)) ///
	note("Data: Chen(2024)") name(fig4, replace)

// Graphing the distribution of gender on job applications
histogram female, fraction barwidth(0.15) ylab(0(0.20)1.00) ///
	xlabel(-.5 " " 0 "0" 0.5 " " 1 "1" 1.5 " ") ///
	xtitle("Gender Of Applicant (1 = Female & 0 = Male)") ///
	ytitle("Fraction") title("Distribution Of Gender On Job Application", size(medsmall)) ///
	note("Data: Chen(2024)") name(fig5, replace)

graph combine fig2 fig3 fig4 fig5, name(indep, replace) iscale(0.50) ycommon

// Graphing the distribution of wages posted
histogram wage_mid, percent kdensity kdenopts(lcolor(orange)) ///
	xtitle("Wage Posted") ///
	title("Distribution Of Posted Wage", size(medsmall)) ///
	note("Data: Chen(2024)") name(figwage, replace)

// Graphing the relationship between wage and major 
twoway (scatter wage_mid business) (lfit wage_mid business), ///
	xtitle("Student's Major (1 = Business & 0 = Computer Science)", size(small)) ///
	ytitle("Wage", size(small)) ///
	xlabel(-.5 " " 0 "0" 0.5 " " 1 "1" 1.5 " ") ///
	title("Relationship Between Posted Wage and Major", size(medsmall)) ///
	legend(off) ///
	name(wagemaj, replace) note("Data: Chen(2024)")
 
graph combine figwage wagemaj, name(wage, replace) iscale(0.50) cols(1)


// Using university ranking data to visualise selectivity and rankings

clear
use Rankings.dta, replace

rename range_wrank range					// Renaming variable for easy access

bysort us range: gen count = _N				// Counting the 'US' variable
bysort us range: keep if _n == 1
keep us range count

// Generating individual count variables for US and China institutions
preserve
keep if us == 0 							// Generating for 'China'
rename count count_china
drop us
tempfile china
save `china', replace
restore

rename count count_us
keep if us == 1								// Generating for 'US'
drop us
merge 1:1 range using `china'			// Merging for common dataset using Range
drop _m 
replace count_china = 0 if count_china == .
replace count_us = 0 if count_us == .

//Graphing the overall world rankings for both US and China institutions

graph bar count_us count_china, over(range, reverse gap(*1.5) ///
	relabel(1 `" "1-" "100" "' 2 `" "101-" "200" "' 3 `" "201-" "300" "' ///
	4 `" "301-" "400" "' 5 `" "401-" "500" "' 6 `" "501-" "600" "' ///
	7 `" "601-" "700" "' 8 `" "701-" "800" "' 9 `" "801-" "900" "' ///
	10 `" "901-" "1000" "' 11 `" "Not" "ranked" "') label(labsize(small))) ///
	bar(1, fi(70) lw(thin)) ///
	bar(2, fi(40) lw(vthin)) ///
	ylabel(0(10)40,labsize(medsmall) angle(horizontal)) ysc(range(0 40)) ///
	title("All Institutions World Rankings", size(medsmall)) ytitle("Number of schools", ///
	size(medsmall))  legend(col(2) order(1 "US" 2 "China") pos(6) ///
	size(small) region(lcolor(black))) plotregion(margin(b=0)) ///
	graphregion(color(white) margin(0)) name(fig6, replace)

clear
use Rankings.dta, replace			// Reloading the data for reclassification

ren range_wrank range

//Generating variable to identify selectivity based on prior assumptions
gen s=1 if selectivity=="985" | selectivity=="Top50"
replace s=2 if selectivity=="211" | selectivity=="Top100"
replace s=3 if selectivity=="none" | selectivity=="Top250"

bys us s range: gen count=_N
bys us s range: keep if _n==1
keep us s range count

// Generating individual count variables for US and China institutions
preserve
keep if us==0						// Generating for 'China'
ren count count_china
drop us
tempfile china
save `china', replace
restore

ren count count_us
keep if us==1								// Generating for 'US'
drop us
merge 1:1 s range using `china'			// Merging for common dataset using Range
drop _m
replace count_china=0 if count_china==.
replace count_us=0 if count_us==.

// Graph for "Very Selective Institutions"
graph bar count_us count_china if s == 1, over(range, reverse gap(*1.5) ///
	relabel(1 `" "1-" "100" "' 2 `" "101-" "200" "' 3 `" "201-" "300" "' ///
	4 `" "301-" "400" "' 5 `" "401-" "500" "' 6 `" "501-" "600" "' ///
	7 `" "601-" "700" "' 8 `" "701-" "800" "' 9 `" "801-" "900" "' ///
	10 `" "901-" "1000" "' 11 `" "Not" "ranked" "') label(labsize(small))) ///
	bar(1, fi(70) lw(thin)) ///
	bar(2, fi(40) lw(vthin)) ///
	ylabel(0(10)40,labsize(medsmall) angle(horizontal)) ysc(range(0 40)) ///
	title("Very Selective Institutions World Rankings", size(medsmall)) ///
	ytitle("Number of schools", ///
	size(medsmall))  legend(col(2) order(1 "US" 2 "China") pos(6) ///
	size(small) region(lcolor(black))) plotregion(margin(b=0)) ///
	graphregion(color(white) margin(0)) name(fig7, replace)
	
// Graph for "Selective Institutions"
graph bar count_us count_china if s == 2, over(range, reverse gap(*1.5) ///
	relabel(1 `" "1-" "100" "' 2 `" "101-" "200" "' 3 `" "201-" "300" "' ///
	4 `" "301-" "400" "' 5 `" "401-" "500" "' 6 `" "501-" "600" "' ///
	7 `" "601-" "700" "' 8 `" "701-" "800" "' 9 `" "801-" "900" "' ///
	10 `" "901-" "1000" "' 11 `" "Not" "ranked" "') label(labsize(small))) ///
	bar(1, fi(70) lw(thin)) ///
	bar(2, fi(40) lw(vthin)) ///
	ylabel(0(10)40,labsize(medsmall) angle(horizontal)) ysc(range(0 40)) ///
	title("Selective Institutions World Rankings", size(medsmall)) ///
	ytitle("Number of schools", ///
	size(medsmall))  legend(col(2) order(1 "US" 2 "China") pos(6) ///
	size(small) region(lcolor(black))) plotregion(margin(b=0)) ///
	graphregion(color(white) margin(0)) name(fig8, replace)

// Graph for "Inclusive Institutions"	
graph bar count_us count_china if s == 3, over(range, reverse gap(*1.5) ///
	relabel(1 `" "1-" "100" "' 2 `" "101-" "200" "' 3 `" "201-" "300" "' ///
	4 `" "301-" "400" "' 5 `" "401-" "500" "' 6 `" "501-" "600" "' ///
	7 `" "601-" "700" "' 8 `" "701-" "800" "' 9 `" "801-" "900" "' ///
	10 `" "901-" "1000" "' 11 `" "Not" "ranked" "') label(labsize(small))) ///
	bar(1, fi(70) lw(thin)) ///
	bar(2, fi(40) lw(vthin)) ///
	ylabel(0(10)40,labsize(medsmall) angle(horizontal)) ysc(range(0 40)) ///
	title("Inclusive Institutions World Rankings", size(medsmall)) ///
	ytitle("Number of schools", ///
	size(medsmall))  legend(col(2) order(1 "US" 2 "China") pos(6) ///
	size(small) region(lcolor(black))) plotregion(margin(b=0)) ///
	graphregion(color(white) margin(0)) name(fig9, replace)

//Combined graph of all rankings based on selectivity
graph combine fig6 fig7 fig8 fig9, name(fig10, replace) ycommon iscale(0.50)

clear 

*********************************************************************************
* 								EMPIRICAL ANALYSIS
*********************************************************************************

use Final_Data, replace				// Saving modified dataset

// Regression Table 1

//Regression to estimate the effect of US education on callback rate

// Column 1
qui reg callback us, cluster(job_id) 	//Regressing callback rate on US education
qui est sto t11							// storing the beta
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing
predict mod1						// Linear predictor for graphing

// Column 2
qui reg callback us exp female wave2 i.lmarket_c i.se_c, cluster(job_id) //Controlling for other variables
est sto t12
qui sum callback if us == 0
qui estadd scalar China r(mean)
predict mod2

// Running Logit model on the above specifications

// Column 3
qui logit callback us, cluster(job_id)
est sto t13
predict mod3

// Column 4
qui margins, dydx(us) predict(p) post
est sto t14

// Column 5
qui logit callback us exp female wave2 i.lmarket_c i.se_c, cluster(job_id)
est sto t15
predict mod4

// Column 6
qui margins, dydx(us exp female wave2 lmarket_c se_c) predict(p) post
est sto t16

esttab t1*, b(%9.3f) se(%9.3f) stats(N r2) keep(us exp female wave2)
	
	
// Regression Table 2

//Baseline regression with fixed effects

// Column 1
qui xtreg callback us i.name_c i.se_c, fe cluster(job_id)
est sto t21
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing
predict mod5

// Column 2
qui xtreg callback us i.name_c i.se_c if business == 1, fe cluster(job_id)
est sto t22
qui sum callback if us == 0	& business == 1		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing
predict mod6

// Column 3
qui xtreg callback us i.name_c i.se_c if business == 0, fe cluster(job_id)
est sto t23
qui sum callback if us == 0	& business == 0		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing
predict mod7

esttab t2*, b(%9.3f) se(%9.3f) stats(N r2 China) keep(us)


//Baseline regression with logit model 
// Column 1
qui logit callback us i.name_c i.se_c, cluster(job_id)
est sto t31
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// Column 2
qui margins, dydx(us name_c se_c) predict(p) post
est sto t32
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// Column 3
qui logit callback us i.name_c i.se_c if business == 1, cluster(job_id)
est sto t33
qui sum callback if us == 0	& business == 1		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// Column 4
qui margins, dydx(us name_c se_c) predict(p) post
est sto t34
qui sum callback if us == 0	& business == 1		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// Column 5
qui logit callback us i.name_c i.se_c if business == 0, cluster(job_id)
est sto t35
qui sum callback if us == 0	& business == 0		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// Column 6
qui margins, dydx(us name_c se_c) predict(p) post
est sto t36
qui sum callback if us == 0	& business == 0		// Getting the average value for China
qui estadd scalar China r(mean)		// Storing


esttab t3*, b(%9.3f) se(%9.3f) stats(N China) keep(us)


// Regression Graph 1

gen businessgraph = "Business" if business == 1
replace businessgraph = "Computer Science" if business == 0

twoway (scatter callback us) (lfit callback us), ///
	xtitle("Country of Education (1 = US & 0 = China)") ///
	xtitle(, size(small)) by(, title("Probability of Callback By Sector", ///
	size(medsmall) span)) by(, legend(off)) name(reg1, replace) ///
	ylab(0(0.1)1) xlab(0(1)1) ///
	by(businessgraph) by(, note("Data: Chen (2024)"))

drop businessgraph
	
//Table 4

// Baseline
qui xtreg callback us uswage_mid i.name_c i.se_c, fe cluster(job_id)
est sto t41
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// < 10
qui xtreg callback us i.name_c i.se_c if pay10==1, fe cluster(job_id)
est sto t42
qui sum callback if us == 0	& pay10 == 1
qui estadd scalar China r(mean)		// Storing

// 10 - 20 
qui xtreg callback us i.name_c i.se_c if pay1020==1, fe cluster(job_id)
est sto t43
qui sum callback if us == 0	& pay1020 == 1
qui estadd scalar China r(mean)		// Storing

// 20 - 30 
qui xtreg callback us i.name_c i.se_c if pay2030==1, fe cluster(job_id)
est sto t44
qui sum callback if us == 0	& pay2030 == 1
qui estadd scalar China r(mean)		// Storing

// 30 - 40 
qui xtreg callback us i.name_c i.se_c if pay3040==1, fe cluster(job_id)
est sto t45
qui sum callback if us == 0	& pay3040 == 1
qui estadd scalar China r(mean)		// Storing

// 50 - 60 
qui xtreg callback us i.name_c i.se_c if pay5060==1, fe cluster(job_id)
est sto t47
qui sum callback if us == 0	& pay5060 == 1
qui estadd scalar China r(mean)		// Storing

// 60 - 70 
qui xtreg callback us i.name_c i.se_c if pay6070==1, fe cluster(job_id)
est sto t48
qui sum callback if us == 0	& pay6070 == 1
qui estadd scalar China r(mean)		// Storing

// 70 - 80
qui xtreg callback us i.name_c i.se_c if pay7080==1, fe cluster(job_id)
est sto t49
qui sum callback if us == 0	& pay7080 == 1
qui estadd scalar China r(mean)		// Storing

// 80 - 90
qui xtreg callback us i.name_c i.se_c if pay8090==1, fe cluster(job_id)
est sto t50
qui sum callback if us == 0	& pay8090 == 1
qui estadd scalar China r(mean)		// Storing

// > 90
qui xtreg callback us i.name_c i.se_c if pay90==1, fe cluster(job_id)
est sto t51
qui sum callback if us == 0	& pay90 == 1
qui estadd scalar China r(mean)		// Storing


esttab t41 t42 t43 t44 t45 t47 t48 t49 t50 t51, ///
b(%9.3f) se(%9.3f) stats(N r2 China) keep(us uswage_mid)


// Plotting the coefficients against the models 

coefplot t42 t43 t44 t45 t47 t48 t49 t50 t51, vertical keep(us) ///
	name(reg2, replace) legend(off) yline(0) ylab(-0.1(0.01)0.02) ///
	asequation swapnames eqrename(t42 = ">10" t43 = "10-20" t44 = "20-30" ///
	t45 = "30-40" t47 = "50-60" t48 = "60-70" t49 = "70-80" t50 = "80-90" ///
	t51 = ">90") ///
	xtitle("Wage Coefficients")  note("Data: Chen (2024)") ///
	title("Regression Coefficients Of Posted Wage", size(medsmall))


//Table 4

// Baseline
qui xtreg callback us uswage_mid i.name_c i.se_c, fe cluster(job_id)
est sto t81
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// < 10
qui xtreg callback us i.name_c i.se_c if pay10==1 & business == 0, fe cluster(job_id)
est sto t82
qui sum callback if us == 0	& pay10 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// < 10
qui xtreg callback us i.name_c i.se_c if pay10==1 & business == 1, fe cluster(job_id)
est sto t83
qui sum callback if us == 0	& pay10 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 10 - 20 
qui xtreg callback us i.name_c i.se_c if pay1020==1 & business == 0, fe cluster(job_id)
est sto t84
qui sum callback if us == 0	& pay1020 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 10 - 20 
qui xtreg callback us i.name_c i.se_c if pay1020==1 & business == 1, fe cluster(job_id)
est sto t85
qui sum callback if us == 0	& pay1020 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 20 - 30 
qui xtreg callback us i.name_c i.se_c if pay2030==1 & business == 0, fe cluster(job_id)
est sto t86
qui sum callback if us == 0	& pay2030 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 20 - 30 
qui xtreg callback us i.name_c i.se_c if pay2030==1 & business == 1, fe cluster(job_id)
est sto t87
qui sum callback if us == 0	& pay2030 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 30 - 40 
qui xtreg callback us i.name_c i.se_c if pay3040==1 & business == 0, fe cluster(job_id)
est sto t88
qui sum callback if us == 0	& pay3040 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 30 - 40
qui xtreg callback us i.name_c i.se_c if pay3040==1 & business == 1, fe cluster(job_id)
est sto t89
qui sum callback if us == 0	& pay3040 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 50 - 60 
qui xtreg callback us i.name_c i.se_c if pay5060==1 & business == 0, fe cluster(job_id)
est sto t90
qui sum callback if us == 0	& pay5060 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 50 - 60 
qui xtreg callback us i.name_c i.se_c if pay5060==1 & business == 1, fe cluster(job_id)
est sto t91
qui sum callback if us == 0	& pay5060 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 60 - 70 
qui xtreg callback us i.name_c i.se_c if pay6070==1 & business == 0, fe cluster(job_id)
est sto t92
qui sum callback if us == 0	& pay6070 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 60 - 70 
qui xtreg callback us i.name_c i.se_c if pay6070==1 & business == 1, fe cluster(job_id)
est sto t93
qui sum callback if us == 0	& pay6070 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// 70 - 80
qui xtreg callback us i.name_c i.se_c if pay7080==1 & business == 0, fe cluster(job_id)
est sto t94
qui sum callback if us == 0	& pay7080 == 1  & business == 0
qui estadd scalar China r(mean)		// Storing

// 70 - 80
qui xtreg callback us i.name_c i.se_c if pay7080==1 & business == 1, fe cluster(job_id)
est sto t95
qui sum callback if us == 0	& pay7080 == 1  & business == 1
qui estadd scalar China r(mean)		// Storing

// 80 - 90
qui xtreg callback us i.name_c i.se_c if pay8090==1 & business == 0, fe cluster(job_id)
est sto t96
qui sum callback if us == 0	& pay8090 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// 80 - 90
qui xtreg callback us i.name_c i.se_c if pay8090==1 & business == 1, fe cluster(job_id)
est sto t97
qui sum callback if us == 0	& pay8090 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing

// > 90
qui xtreg callback us i.name_c i.se_c if pay90==1 & business == 0, fe cluster(job_id)
est sto t98
qui sum callback if us == 0	& pay90 == 1 & business == 0
qui estadd scalar China r(mean)		// Storing

// > 90
qui xtreg callback us i.name_c i.se_c if pay90==1 & business == 1, fe cluster(job_id)
est sto t99
qui sum callback if us == 0	& pay90 == 1 & business == 1
qui estadd scalar China r(mean)		// Storing


esttab t8* t9*, ///
b(%9.3f) se(%9.3f) stats(N r2 China) keep(us)


coefplot t82 t84 t86 t88 t90 t92 t94 t96 t98 , bylabel(Computer Science) ///
	asequation swapnames eqrename(t82 = ">10" t84 = "10-20" t86 = "20-30" ///
	t88 = "30-40" t90 = "50-60" t92 = "60-70" t94 = "70-80" t96 = "80-90" ///
	t98 = ">90") || t83 t85 t87 t89 t91 t93 t95 t97 t99, asequation swapnames ///
	eqrename(t83 = ">10" t85 = "10-20" t87 = "20-30" t89 = "30-40" t91 = "50-60" ///
	t93 = "60-70" t95 = "70-80" t97 = "80-90" t99 = ">90")bylabel(Business) ///
	keep(us) vertical yline(0) nokey xtitle("Posted Wage Deciles") ///
	note("Data: Chen (2024)") name(regfig5, replace)
	
*********************************************************************************
* 								APPENDIX
*********************************************************************************


// Appendix Table 1
// Including interaction terms of 'US' Education and Salary decile

// Baseline
qui xtreg callback us uswage_mid i.name_c i.se_c, fe cluster(job_id)
est sto ta1
qui sum callback if us == 0			// Getting the average value for China
qui estadd scalar China r(mean)		// Storing

// < 10
qui xtreg callback us us##pay10 i.name_c i.se_c, fe cluster(job_id)
est sto ta2
qui sum callback if us == 0	& pay10 == 1
qui estadd scalar China r(mean)		// Storing

// 10 - 20 
qui xtreg callback us us##pay1020 i.name_c i.se_c, fe cluster(job_id)
est sto ta3
qui sum callback if us == 0	& pay1020 == 1
qui estadd scalar China r(mean)		// Storing

// 20 - 30 
qui xtreg callback us us##pay2030 i.name_c i.se_c, fe cluster(job_id)
est sto ta4
qui sum callback if us == 0	& pay2030 == 1
qui estadd scalar China r(mean)		// Storing

// 30 - 40 
qui xtreg callback us us##pay3040 i.name_c i.se_c, fe cluster(job_id)
est sto ta5
qui sum callback if us == 0	& pay3040 == 1
qui estadd scalar China r(mean)		// Storing

// 50 - 60 
qui xtreg callback us us##pay5060 i.name_c i.se_c, fe cluster(job_id)
est sto ta6
qui sum callback if us == 0	& pay5060 == 1
qui estadd scalar China r(mean)		// Storing

// 60 - 70 
qui xtreg callback us us##pay6070 i.name_c i.se_c, fe cluster(job_id)
est sto ta7
qui sum callback if us == 0	& pay6070 == 1
qui estadd scalar China r(mean)		// Storing

// 70 - 80
qui xtreg callback us us##pay7080 i.name_c i.se_c, fe cluster(job_id)
est sto ta8
qui sum callback if us == 0	& pay7080 == 1
qui estadd scalar China r(mean)		// Storing

// 80 - 90
qui xtreg callback us us##pay8090 i.name_c i.se_c, fe cluster(job_id)
est sto ta9
qui sum callback if us == 0	& pay8090 == 1
qui estadd scalar China r(mean)		// Storing

// > 90
qui xtreg callback us us##pay90 i.name_c i.se_c, fe cluster(job_id)
est sto ta10
qui sum callback if us == 0	& pay90 == 1
qui estadd scalar China r(mean)		// Storing


esttab ta*, b(%9.3f) se(%9.3f) stats(N r2 China) keep(us uswage_mid 1.us#1.*)

*********************************************************************************
*********************************************************************************

log close

*********************************************************************************
