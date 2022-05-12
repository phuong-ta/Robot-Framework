*** Settings ***
Documentation       Car dealer website test PartB

Library             SeleniumLibrary
Library             Dialogs
Library             Process
Library             Collections
Library             FakerLibrary

Test Setup          Start Container
Suite Teardown       Stop Container


*** Variables ***
${LOGIN URL}            http://localhost:3000
${BROWSER}              Chrome
${RemoveValue}          SKODA
@{CarNames}=            SKODA       TESLA       BMW         
@{CarModels}=           Electric    Gas         Diesel     
@{CarMileages}=         2016        2018        2019        2020        2021   
@{CarYears}=            2015        2017        2019        2021        2022
@{CarPlates}=           ABC-123     DEF-456     XYZ-789     FIN-159     VIN-654
@{List}

*** Test Cases ***
Open Web           
    Open Website
    
Add cars
    Add ten cars

Get Website Elements
    Get all elements
    Remove car 
    Check again

*** Keywords ***
Open Website
    Open BROWSER            ${LOGIN URL}        ${BROWSER}

Add ten cars
    FOR    ${i}    IN RANGE    10    
        ${CarName}=             Random Element      ${CarNames}
        ${CarModel}=            Random Element      ${CarModels}
        ${CarMiliage}=          Random Element      ${CarMileages}
        ${CarYear}=             Random Element      ${CarYears}
        ${CarPalte}=             Random Element      ${CarPlates}
        Go To           http://localhost:3000/add    
        Input Text      make-input      ${CarName}
        Input Text      model-input      ${CarModel}
        Input Text      mileage-input     ${CarMiliage}
        Input Text      year-input      ${CarYear}
        Input Text      plate-input      ${CarPalte}
        Click Button    Add a new car
    END
    

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
        Log to console   There is no ${RemoveValue} in car list
    ELSE
        Log to console    There is ${RemoveValue} in car list. Check again!
    END

Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach

Stop Container
    Capture Page Screenshot     second-screenshot.png
    Pause Execution
    Close Browser
    Run Process     docker-compose    down
