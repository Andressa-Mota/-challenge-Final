*** Settings ***

Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           RequestsLibrary
Resource          env.resource
Resource          pages/user-page.resource
Resource          pages/films-page.resource
Resource          pages/user-page.resource
Resource          pages/theaters-page.resource
Resource          pages/sessions-page.resource
Resource           pages/reservations-page.resource
Resource           check.resource


*** Keywords ***

iniciar sessao
     ${headers}=    Create Dictionary    Content-Type=application/json
    Create Session    cinema    ${BASE_URL}   headers=${headers}

importar json estatico
    [Arguments]    ${nome_arquivo}
    ${json}       Load JSON From File   ${CURDIR}/fixtures/${nome_arquivo}    encoding=UTF-8
    RETURN       ${json}

