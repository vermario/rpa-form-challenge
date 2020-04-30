*** Settings ***
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.Tables
Library           RPA.FileSystem
Library           RPA.Browser
Library           Collections
Variables         variables.py

*** Keywords ***
Download the excel file and fill the forms based on the data
    Download the excel file for the challenge locally
    ${peopleData}=    Collect people data from the Excel file
    Open the RPA challenge website
    Start the Challenge
    FOR    ${person}    IN    @{peopleData}
        Run Keyword And Continue On Failure    Fill and submit the form for one person    ${person}
    END
    Take screenshot of the results
    [Teardown]    Close browser

Download the excel file for the challenge locally
    HTTP GET    ${EXCEL_FILE_URL}    ${EXCEL_FILE_NAME}

Collect people data from the Excel file
    Open Workbook    ${EXCEL_FILE_NAME}
    ${worksheet}=    Read Worksheet    header=${TRUE}
    ${data_table}=    Create Table    ${worksheet}
    Filter Empty Rows    ${data_table}
    ${people}=    Create List
    FOR    ${row}    IN    @{data_table}
        ${person}=    Create Dictionary
        Set To Dictionary    ${person}    first_name    ${row.First_Name}
        Set To Dictionary    ${person}    last_name    ${row.Last_Name}
        Set To Dictionary    ${person}    company_name    ${row.Company_Name}
        Set To Dictionary    ${person}    role_in_company    ${row.Role_in_Company}
        Set To Dictionary    ${person}    address    ${row.Address}
        Set To Dictionary    ${person}    email    ${row.Email}
        Set To Dictionary    ${person}    phone_number    ${row.Phone_Number}
        Append To List    ${people}    ${person}
    END
    Close Workbook
    [Return]    ${people}

Open the RPA challenge website
    Open Available Browser    ${RPA_CHALLENGE_URL}

Start the Challenge
    Click button    Start

Fill and submit the form for one person
    [Arguments]    ${person}
    Input Text    //*[@ng-reflect-name="labelEmail"]    ${person["email"]}
    Input Text    //*[@ng-reflect-name="labelPhone"]    ${person["phone_number"]}
    Input Text    //*[@ng-reflect-name="labelFirstName"]    ${person["first_name"]}
    Input Text    //*[@ng-reflect-name="labelRole"]    ${person["role_in_company"]}
    Input Text    //*[@ng-reflect-name="labelAddress"]    ${person["address"]}
    Input Text    //*[@ng-reflect-name="labelCompanyName"]    ${person["company_name"]}
    Input Text    //*[@ng-reflect-name="labelLastName"]    ${person["last_name"]}
    Click button    Submit

Take screenshot of the results
    ${congratulations_element}=    Set Variable    css=.congratulations
    Wait Until Element Is Visible    ${congratulations_element}
    Capture Element Screenshot    ${congratulations_element}    challenge-results.png
