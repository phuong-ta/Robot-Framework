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
${speed}    50
${port1}    COM6
${port2}    COM7

*** Test Cases ***   

Templated test case 
            
    [Template]    Send check
    ${speed}                ${name}        
	#  55                      Phuong Ta


   