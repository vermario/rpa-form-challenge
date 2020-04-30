*** Settings ***
Documentation     Robot to solve the first challenge at rpachallenge.com, which consists of
...               filling
Resource          keywords.robot

*** Tasks ***
Solve the RPA form challenge
    Download the Excel file for the challenge locally
    ${peopleData}=    Collect people data from the Excel file
    Open the RPA challenge website
    Click button    Start
    FOR    ${person}    IN    @{peopleData}
        Run Keyword And Continue On Failure    Fill and submit the form for one person    ${person}
    END
    Take screenshot of the results
    [Teardown]    Close browser
