*** Settings ***
Documentation     Example of morse transmitter test
...
...               Change this example to use data driven style 
...               Test with different texts and speeds


Library           MorseDecoderLibrary.py
Library           OperatingSystem
Library           FakerLibrary       locale=fi_FI
Library           String

#Test Template    Send check
*** Variables ***
${name}  Anna!!!
${speed}    55

*** Test Cases ***   
Templated test case               
    [Template]    Send check
    ${speed}                ${name}
	55                       Phuong Ta

*** Keywords ***
Send check

    [Arguments]    ${Input_Speed}    ${Name}

	# convert input text and convert if inout text has
	
	${ConvertName}    Replace String Using Regexp    ${Name}    [^a-zA-Z${SPACE}]   X
    ${ExpectedName}    Convert To Upper Case    ${ConvertName}
	# check input values
    Log    ${Input_Speed}
	Log    ${ExpectedName}
	# Run and check results

	Set Speed    ${Input_Speed}
    Send text    ${Name}
	Speed should be    ${Input_Speed}
	Text should be    ${ExpectedName}
    
   