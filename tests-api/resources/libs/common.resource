*** Settings ***

Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           RequestsLibrary
Resource          env.resource
Resource          pages/authentication-page.resource


*** Keywords ***

iniciar sessao
     ${headers}=    Create Dictionary    Content-Type=application/json
    Create Session    cinema    ${BASE_URL}   headers=${headers}

importar json estatico
    [Arguments]    ${nome_arquivo}
    ${json}       Load JSON From File   ${CURDIR}/fixtures/${nome_arquivo}    encoding=UTF-8
    Log To Console     ${CURDIR}
    RETURN       ${json}

Conferência de cadastro
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    _id  

Conferência de erro
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Contain    ${response['message']}    ${mensagem_esperada}

Conferência de login
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    authorization
    Should Contain    ${response['message']}    Login realizado com sucesso

Conferência de lista de usuários
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    usuarios
    ${quantidade}=    Get Length    ${response['usuarios']}
    Should Be True    ${quantidade} > 0

Conferência de sucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Be Equal As Strings    ${response['message']}    ${mensagem_esperada}