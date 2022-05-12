*** Settings ***
     
Library           OperatingSystem
Library           String
Library            ../MorseDecoderLibrary.py  	COM6		COM7  

*** Keywords ***      

Turn off WPM and IMM
	[Arguments]		${controller}
	Set Wpm		${controller}
	Set Imm		${controller}

Send check
    [Arguments]    ${Input_Speed}    ${Name}	
	${ConvertName}    Replace String Using Regexp    ${Name}    [^a-zA-Z${SPACE}]   X
    ${ExpectedName}    Convert To Upper Case    ${ConvertName}
	Set Speed    ${Input_Speed}
    Send text    ${Name}
	Text should be    ${ExpectedName}
	Speed should be    ${Input_Speed}
	
Turn on WPM and IMM
	[Arguments]		${controller}
	Set Wpm		${controller}
	Set Imm		${controller}
	
	

