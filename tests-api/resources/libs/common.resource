*** Settings ***

Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           RequestsLibrary
Resource          env.resource
Resource          pages/user-page.resource


*** Keywords ***

iniciar sessao
     ${headers}=    Create Dictionary    Content-Type=application/json
    Create Session    cinema    ${BASE_URL}   headers=${headers}

importar json estatico
    [Arguments]    ${nome_arquivo}
    ${json}       Load JSON From File   ${CURDIR}/fixtures/${nome_arquivo}    encoding=UTF-8
    RETURN       ${json}

Conferência de cadastro
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    _id  

Conferência de cadastro adm
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    role 
    Should Be Equal As Strings    ${response['data']['role']}    admin 
Conferência de erro
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Contain    ${response['message']}    ${mensagem_esperada}

Conferência de login
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response['data']}    _id
    Dictionary Should Contain Key    ${response['data']}    token

Conferência de dados do usuário
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    _id
    Dictionary Should Contain Key    ${response['data']}    name
    Dictionary Should Contain Key    ${response['data']}    email
    Dictionary Should Contain Key    ${response['data']}    role
    ...    
Conferência de lista de usuário
    [Arguments]    ${response}
     Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${quantidade}=    Get Length    ${response['data']} 
    Should Be True    ${quantidade} > 0

Conferência de sucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Be Equal As Strings    ${response['message']}    ${mensagem_esperada}

Conferência de delete com seucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key       ${response}    message
    Should Be Equal As Strings      ${response['message']}    ${mensagem_esperada}

Conferência de atualização de usuário
    [Arguments]    ${response}    ${nome_esperado}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${dados_usuario}=    Set Variable    ${response['data']}
    Should Be Equal As Strings       ${dados_usuario['name']}    ${nome_esperado}
    Dictionary Should Contain Key    ${dados_usuario}    _id
    Dictionary Should Contain Key    ${dados_usuario}    email