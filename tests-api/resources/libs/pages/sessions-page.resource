*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Resource          ../common.resource

*** Keywords ***

Listar sessoes
    [Arguments]    ${status_esperado}
    ${resposta}=   GET On Session    cinema    /sessions    expected_status=${status_esperado}
    RETURN         ${resposta}

Criar sessao com token
    [Arguments]    ${token}    ${dados_da_sessao}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   POST On Session    cinema    /sessions    json=${dados_da_sessao}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}