*** Settings ***
Documentation       Car dealer website test

Library             SeleniumLibrary
Library             Dialogs
Library             Process
Library             Collections

Test Setup          Start Container
Suite Teardown       Stop Container


*** Variables ***
${LOGIN URL}      http://localhost:3000
${BROWSER}        Chrome
${RemoveValue}      SKODA
@{CarNames}=        SKODA       TESLA       BMW     TOYOTA      POSCHER     Audi
@{CarModel}=        Electric    Gas         Diesel     
@{CarMileage}=      2016        2018        2019    2020        2021   
@{CarYear}=         2015        2017        2019    2021        2022 
@{List}

*** Test Cases ***
Open Web           
    Open Website
    
Add cars
    [Template]    Add cars
    TESLA           Electric            2020          2018
    BMW             Gas                 2022          2019
    TOYOTA          Electric            2020          2018
    TOYOTA          Electric            2020          2018
    POSCHER         Electric            2020          2018
    SKODA           Electric            2020          2018
    Audi            Electric            2020          2018
    SKODA           Gas                 2022          2019
    SKODA           Gas                 2022          2019
    TESLA           Electric            2020          2018

Get Website Elements
    Get all elements
    Remove car 
    Check again

*** Keywords ***
Open Website
    Open BROWSER            ${LOGIN URL}        ${BROWSER}

Add cars
    [Arguments]    ${CarName}       ${CarModel}     ${CarMiliage}       ${CarYear} 

    Go To           http://localhost:3000/add    
    Input Text      make-input      ${CarName}
    Input Text      model-input      ${CarModel}
    Input Text      mileage-input     ${CarMiliage}
    Input Text      year-input      ${CarYear}
    Click Button    Add a new car

Get all elements
    Capture Page Screenshot     first-screenshot.png
    ${elements}=         Get Web Elements         css:div#car-container a div.car div.car-specs.car-make span.field-value

    FOR    ${element}    IN    @{elements}
    ${text}=    Get Text    ${element}
    Append To List	    ${List}	    ${text}
    END

    Log     ${List}
Remove car
    ${count} =	Count Values In List	${List}	${RemoveValue} 
    log     ${count}
    FOR    ${i}    IN RANGE    ${count}
        ${x} =	Get Index From List 	${List}	    ${RemoveValue}   
        ${elementList}=         Get Web Elements         //div[@id="car-container"]/a
        Open Context Menu       ${elementList}[${x}]
        Handle Alert        ACCEPT
        Remove From List	    ${List}	${x}
    END

Check again
    ${y} =	Get Index From List 	${List}	    ${RemoveValue}
    IF    ${y} == -1
        Log    This line is NOT executed.
    ELSE
        Log    This line IS executed.
    END

Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach

Stop Container
    Capture Page Screenshot     second-screenshot.png
    Pause Execution
    Close Browser
    Run Process     docker-compose    down
