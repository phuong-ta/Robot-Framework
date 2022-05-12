*** Settings ***
Library                             OperatingSystem
Library                             Collections
Library                             FakerLibrary       locale=fi_FI
Library                             String
Library                             Dialogs

*** Variables ***
${file2}=  part2.txt    # this file was created by user before
${file3}=    part3.txt

***Test Cases***
Try to print a list     # part1 + part2
    # create a list os name
    ${names}=    FakerLibrary.Words    # get a list of random names
    Get Random Names       ${names}    # set agrument for test case (part1)
    Remove Existing Address File        ${file2}    # set agrument for test case (part2)

Create and add content to new file, then check address and remove file.     #Part 3
    Remove an existing file 
    Create new file with content
    Check address and remove file

*** Keywords ***

Get Random Names
    [Arguments]    ${word}        # call agrument 
    Log     ${word}                # print a list of random names
    Get Length    ${word}        # print number of names

Remove Existing Address File    # part 2
    [Arguments]    ${file}     # pass agrument to keyword
    ${file2Content}=     Get File    ${file}    # read file
    ${readContent}=    Split To Lines    ${file2Content}    0    1    # show content of first line and number of line
    Log    ${file}
    Log    ${readContent}
    #Remove Files    ${file}

Remove an existing file     # part 3
    ${removeFile}=     Should Not Exist    ${file3}
    IF    ${removeFile}
        Log    Can not found this file 
    ELSE
        Log    check code again!
    END
Create new file with content
    # create 5 users with random names and random address
    ${user1}=    FakerLibrary.Name    # create a random name 
    ${user2}=    FakerLibrary.Name Female    # create a random female name
    ${user3}=    FakerLibrary.Name Male    # create a random male name
    ${user4}=    FakerLibrary.Name    # create a random name
    ${user5}=    FakerLibrary.Name    # create a random name
    ${street}=    FakerLibrary.Street Address     # create a random street
    ${postcode}=        FakerLibrary.Postcode    #create a random post code
    ${city}=    FakerLibrary.City    #create a random city
    # print selection dialog with five random names
    ${showName}=    Get Selection From User    Choose one name    ${user1}    ${user2}    ${user3}    ${user4}    ${user5}

    # Create file with name and address(3 seperate lines)
    Create File    ${file3}    ${showName}\n
    Append To File    ${file3}    ${street}\n
    Append To File    ${file3}    ${postcode}\n
    Append To File    ${file3}    ${city}

Check address and remove file
    ${file3Content}=     Get File    ${file3}        # read file
    ${readContent}=    Split To Lines    ${file3Content}    1     # return how many lines from line 1 and content os each line
    Remove File    ${file3}
    

    