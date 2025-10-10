*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Resource          ../common.resource

*** Keywords ***
Listar salas
    [Arguments]    ${status_esperado}
    ${resposta}=   GET On Session    cinema    /theaters    expected_status=${status_esperado}
    RETURN         ${resposta}

Criar sala com token
    [Arguments]    ${token}    ${dados_da_sala}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   POST On Session    cinema    /theaters    json=${dados_da_sala}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}