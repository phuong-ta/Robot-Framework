*** Settings ***
Documentation       Car dealer website test

Library             SeleniumLibrary
Library             Dialogs
Library             Process
Library             OperatingSystem
Suite Setup          Start Container
Suite Teardown       Stop Container

*** Variables ***
${LOGIN URL}      http://localhost:3000
${BROWSER}        Chrome
@{CarName}          TESLA           HYNDAI         TOYOTA           
@{CarModel}         Electric        Gas             AGAS            
@{CarMiliage}       2020            2011            2015            
@{CarYear}          2018            2021            2022            
    
*** Test Cases ***  

Test open BROWSER and click to add
    Open WebPage

Add three cars              
    [Template]    Add cars
    ${CarName}[0]           ${CarModel}[0]          ${CarMiliage}[0]          ${CarYear}[0]
    ${CarName}[1]           ${CarModel}[1]          ${CarMiliage}[1]          ${CarYear}[1]
    ${CarName}[2]           ${CarModel}[2]          ${CarMiliage}[2]          ${CarYear}[2]


*** Keywords ***
Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach

Stop Container
    Capture Page Screenshot    second-screenshot.png
    Pause Execution
    Close Browser
    Run Process     docker-compose    down

Open WebPage
    Open Browser    ${LOGIN URL}    ${BROWSER} 
    Maximize Browser Window   
    Capture Page Screenshot    first-screenshot.png

Add cars
    [Arguments]    ${CarName}       ${CarModel}     ${CarMiliage}       ${CarYear} 

    Go To           http://localhost:3000/add    
    Input Text      make-input      ${CarName}
    Input Text      model-input      ${CarModel}
    Input Text      mileage-input     ${CarMiliage}
    Input Text      year-input      ${CarYear}
    Click Button    Add a new car


