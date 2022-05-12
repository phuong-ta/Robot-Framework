*** Settings ***
Documentation     Example of morse transmitter test
...
...               Change this example to use data driven style 
...               Test with different texts and speeds

Library           OperatingSystem
Library           String
Library           MorseDecoderLibrary.py        ${port1}        ${port2}      
Resource          Resources/testKeyWord.robot    
Test Setup        Turn off WPM and IMM         OFF
Test Teardown     Turn on WPM and IMM           ON
#Test Template    Send check
*** Variables ***
${name}  Anna!!!
${speed}    10
${port1}    COM6
${port2}    COM7

*** Test Cases ***   

Templated test case 
            
    [Template]    Send check
    ${speed}                ${name}        
	#  55                      Phuong Ta

Whatever speed
    [Tags]      Default speed
    To check with whatever speed        100

Speed with range 10%
    [Tags]      Speed with range
    To check speed with range        ${speed}

Expected speed is equal input speed
    [Tags]      Exactly speed
    Comprate input speed with expected speed    ${speed}