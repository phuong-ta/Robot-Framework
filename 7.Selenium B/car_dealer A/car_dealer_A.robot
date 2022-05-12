*** Settings ***
Documentation       Car dealer website test PartA

Library             SeleniumLibrary
Library             Dialogs
Library             Process
Library             Collections

Test Setup          Start Container
Suite Teardown       Stop Container


*** Variables ***
${LOGIN URL}      http://localhost:3000
${BROWSER}        Chrome
${RemoveValue}      ABC-123
@{List}

*** Test Cases ***
Open Web           
    Open Website
    
Add cars
    [Template]    Add cars
    TESLA           Electric            2020          2018          XFT-456
    BMW             Gas                 2022          2019          CDE-456
    TOYOTA          Electric            2020          2018          XYZ-789
    TOYOTA          Electric            2020          2018          ABC-123
    POSCHER         Electric            2020          2018          FIN-556
    TESLA           Electric            2020          2018          VIN-989

Get Website Elements
    Get all elements
    Remove car 
    Check again

*** Keywords ***
Open Website
    Open BROWSER            ${LOGIN URL}        ${BROWSER}

Add cars
    [Arguments]    ${CarName}       ${CarModel}     ${CarMiliage}       ${CarYear}      ${CarPalte}

    Go To           http://localhost:3000/add    
    Input Text      make-input      ${CarName}
    Input Text      model-input      ${CarModel}
    Input Text      mileage-input     ${CarMiliage}
    Input Text      year-input      ${CarYear}
    Input Text      plate-input      ${CarPalte}
    Click Button    Add a new car

Get all elements
    Capture Page Screenshot     first-screenshot.png
    ${elements}=         Get Web Elements         css:div#car-container a div.car div.car-specs.car-plate span.field-value

    FOR    ${element}    IN    @{elements}
    ${text}=    Get Text    ${element}
    Append To List	    ${List}	    ${text}
    END

    Log     ${List}
Remove car
    ${x} =	Get Index From List 	${List}	    ${RemoveValue}   
    ${elementList}=         Get Web Elements         //div[@id="car-container"]/a
    Open Context Menu       ${elementList}[${x}]
    Handle Alert        ACCEPT
    Remove From List	    ${List}	${x}

Check again
    ${y} =	Get Index From List 	${List}	    ${RemoveValue}
    IF    ${y} == -1
        Log to console   There is no ${RemoveValue} in this car list
    ELSE
        Log to console   There is ${RemoveValue} in this car list
    END

Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach

Stop Container
    Capture Page Screenshot     second-screenshot.png
    Pause Execution
    Close Browser
    Run Process     docker-compose    down
