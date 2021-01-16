*-- FUNCTION WaitUntil(Day_s, Time_s)-----------------------------------------
*         Name: WaitUntil(Day_s, Time_s)             Docs:            
*  Description: Sleeps until a specified Day and Time       
*       Author: HBExplorer        
* Date created: 01/5/2021              Date updated: 01/5/2021    
* Time created: 10:39:51AM            Time updated: 10:39:51AM  
*    Copyright: HBExplorer 2021           
*-----------------------------------------------------------------------------
*    Arguments: Day_s                          Day of Week e.g. Monday, Wednesday, Sunday
*             : Time_s                   Time to sleep until e.g. 13:15, 12:00, 23:59
* Return Value: (.T.)    
*-----------------------------------------------------------------------------
Function WaitUntil( Target_Day_s, Target_Time_s )
Local Target_Time_in_Days_n := 0
Local Target_Time_in_Hours_n := 0
Local Target_Time_in_Minutes_n := 0
Local Target_Time_in_Seconds_n := 0
Local Total_Target_Time_in_Seconds_n := 0
Local Target_Array_a := {}
Local Current_Date_d := DATE()
Local Current_Day_s := ""
Local Current_Time_s := TIME()
Local Current_Seconds_n := 0
Local Next_Date_d
Local Next_Seconds_n := 0

Current_Day_s := Proper( CDOW( Current_Date_d ) )
Current_Seconds_n := TimeToSec( Current_Time_s )
Next_Seconds_n := TimeToSec( Target_Time_s )
Target_Day_s := Proper( Target_Day_s )

SetCancel(.T.)

Next_Date_d := Get_Future_Date_From_DayofWeek( Target_Day_s )

/* 
	If the Target Date is the same as Today, but the Target Time is later or equal to the Current Time,
  		then just calculate the number of seconds between Now and Then.

	Else If the Target Date is the same as Today, but the Target Time is less than the Current Time, then add 7 to the Current Date ; it will be next week.
*/
IF Target_Day_s == Current_Day_s
	IF Next_Seconds_n >= Current_Seconds_n
		Total_Target_Time_in_Seconds_n := Next_Seconds_n - Current_Seconds_n
		?
		? "Waiting for ", Total_Target_Time_in_Seconds_n, " Total seconds"
		?
	ELSE
		Next_Date_d := Next_Date_d + 7
		Target_Array_a := FT_Elapsed( Current_Date_d, Next_Date_d, Current_Time_s, Target_Time_s )	
		Target_Time_in_Days_n := AllTrim( Str( Target_Array_a[ 1, 2 ] ) )
		Target_Time_in_Hours_n := AllTrim( Str( Target_Array_a[ 2, 1 ] ) ) 
		Target_Time_in_Minutes_n := AllTrim( Str( Target_Array_a[ 3, 1 ] ) ) 
		Target_Time_in_Seconds_n := AllTrim( Str( Target_Array_a[ 4, 1 ] ) )
		Total_Target_Time_in_Seconds_n :=  Target_Array_a[ 4, 2 ]
		?
		? "Waiting for ", Target_Time_in_Days_n, " days, ", Target_Time_in_Hours_n, " hours, ", Target_Time_in_Minutes_n, " minutes, ", Target_Time_in_Seconds_n, " seconds"
		?

	ENDIF
Else
	Target_Array_a := FT_Elapsed( Current_Date_d, Next_Date_d, Current_Time_s, Target_Time_s )	
	Target_Time_in_Days_n := AllTrim( Str( Target_Array_a[ 1, 2 ] ) )
	Target_Time_in_Hours_n := AllTrim( Str( Target_Array_a[ 2, 1 ] ) ) 
	Target_Time_in_Minutes_n := AllTrim( Str( Target_Array_a[ 3, 1 ] ) ) 
	Target_Time_in_Seconds_n := AllTrim( Str( Target_Array_a[ 4, 1 ] ) )
	Total_Target_Time_in_Seconds_n :=  Target_Array_a[ 4, 2 ]
	?
	? "Waiting for ", Target_Time_in_Days_n, " days, ", Target_Time_in_Hours_n, " hours, ", Target_Time_in_Minutes_n, " minutes, ", Target_Time_in_Seconds_n, " seconds"
	?

ENDIF 

FT_Sleep( Total_Target_Time_in_Seconds_n )


Return Nil


*-- FUNCTION Get_Day_Number(Day_s)--------------------------------------------
*         Name: Get_Day_Number(Day_s)      Docs:            
*  Description: Get Number of Day of Week, from Day Name
*       Author: HBExplorer        
* Date created: 01/5/2021              Date updated: 01/5/2021    
* Time created: 12:51:32PM            Time updated: 012:51:32PM  
*    Copyright: HBExplorer 2021
*-----------------------------------------------------------------------------
*    Arguments: Day_s                        
* Return Value: Nth_Day_n        
* 
*-----------------------------------------------------------------------------
Function Get_Day_Number(Day_s)
Local Nth_Day_n := 0
Local Days_a := { ;
						"Sunday", ;
						"Monday", ;
						"Tuesday", ;
						"Wednesday", ;
						"Thursday", ;
						"Friday", ;
						"Saturday" ;
								}

Nth_Day_n := AScan( Days_a, Day_s )
	  
Return Nth_Day_n




*-- FUNCTION Get_Future_Date_From_DayofWeek(Day_s) ---------------------------
*         Name: Get_Future_Date_From_DayofWeek()Writer}
*  Description: Return the Date from a Day of the Week
*  If today is 01/10 Wednesday, then Get_Future_Date_From_DayofWeek( "Thursday" ) is 01/11.
*  If today is 01/10 Wednesday, then Get_Future_Date_From_DayofWeek( "Monday" ) is 01/15.
*        
*       Author: HBExplorer        
* Date created: 1/5/2021              Date updated: 01/5/2021    
* Time created: 2:22:57PM             Time updated: 02:22:57PM   
*    Copyright: HBExplorer 2021
*-----------------------------------------------------------------------------
* Arguments: Day_s                        
* Return Value: NextDate_d
*
*-----------------------------------------------------------------------------

Function Get_Future_Date_From_DayOfWeek(Day_s)

Local Current_Date_d := DATE()
Local Current_Day := ""
Local Current_Day_Number_n := 0
Local Next_Date_d	 
Local Next_Day_Number_n := 0
Local Number_of_Days_n := 0

Current_Day_Number_n := Dow( Current_Date_d )
Next_Day_Number_n := Get_Day_Number(Day_s)

If	Next_Day_Number_n < Current_Day_Number_n
	Number_of_Days_n := 7-(Current_Day_Number_n-Next_Day_Number_n)
Else 
	Number_of_Days_n := Next_Day_Number_n-Current_Day_Number_n
Endif

Next_Date_d := Current_Date_d + Number_of_Days_n

Return Next_Date_d



*-- FUNCTION WaitUntil(Day_s, Time_s)-----------------------------------------
*         Name: WaitUntil(Day_s, Time_s)             Docs:            
*  Description: Sleeps until a specified Day and Time       
*       Author: HBExplorer        
* Date created: 01/7/2021              Date updated: 01/7/2021    
* Time created: 12:11:00PM            Time updated: 12:11:00PM  
*    Copyright: HBExplorer 2021           
*-----------------------------------------------------------------------------
*    Arguments: Day_s                          Day of Week e.g. Monday, Wednesday, Sunday
*             : Time_s                   Time to sleep until e.g. 13:15, 12:00, 23:59
* Return Value: (.T.)    
*-----------------------------------------------------------------------------
/*
Function WaitUntil( Day_s, Time_s )
Local Target_Time_in_Seconds_n := 0
Local Target_Array_a := {}
Local CurrentDate_d := DATE()
Local CurrentTime_s := TIME()
Local NextDate_d

SetCancel(.T.)
NextDate_d := Get_Future_Date_From_DayofWeek( Day_s )

Do While DATE() <> NextDate_d .AND. TimeToSecs(TIME()) < TimeToSecs(Time_s)
	FT_Sleep( 1 )
	IF DATE() == NextDate_d .AND. TimeToSecs(TIME()) > TimeToSecs(Time_s)
	ENDIF 
Target_Array_a := FT_Elapsed( CurrentDate_d, NextDate_d, CurrentTime_s, Time_s )
Target_Time_in_Seconds_n := Target_Array_a[ 4, 2 ]

? "Starting Now " + Time()
	  
Return Nil
*/



// From SuperLib
FUNCTION PROPER(cInString)
local nIter,cOutString,cThisChar,lCapNext

lCapNext   := .T.
cOutString := ''

*- loop for length of string
FOR nIter = 1 TO LEN(cInString)
  cThisChar  := SUBST(cInString,nIter,1)
  *- if its not alpha,cap the next alpha character
  IF !UPPER(cThisChar) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ'"
    lCapNext := .T.
  ELSE
    *- capitalise it or lower() it accordingly
    IF lCapNext
      cThisChar := UPPER(cThisChar)
      lCapNext  := .F.
    ELSE
      cThisChar := LOWER(cThisChar)
    ENDIF
  ENDIF
  *- add it to the cOutString
  cOutString += cThisChar
NEXT
RETURN cOutString



