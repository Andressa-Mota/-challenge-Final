*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Library        FakerLibrary
Resource          ../common.resource

*** Keywords ***
Setup da Suíte
    iniciar sessao



# --- Keywords de Autenticação e Login ---
Cadastrar usuario e fazer login
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    user.json
    ${auth_body}=   Get From Dictionary    ${json}    usuario_valido
    ${password}=   Get From Dictionary   ${auth_body}    password
    ${email_rand}=   Generate Random String    6    [LOWER]
    Set To Dictionary   ${auth_body}    email    ${email_rand}@mail.com
    ${nome_rand}=    Generate Random String    8    [LOWER]
    Set To Dictionary   ${auth_body}    name     User ${nome_rand} 
    POST On Session    cinema    /auth/register    json=${auth_body}    expected_status=any
    # ---  LOGIN ---
    ${login_body}=   Create Dictionary    email=${email_rand}@mail.com    password=${password}
    ${resposta_login}=   POST On Session    cinema    /auth/login    json=${login_body}    expected_status=${status_esperado} 
    RETURN  ${resposta_login}
Cadastrar usuario valido
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    user.json
    ${body}=       Get From Dictionary    ${json}    usuario_valido
    ${email_rand}=    Generate Random String    6    [LOWER]
    Set To Dictionary    ${body}    email    ${email_rand}@mail.com
     ${nome_rand}=    Generate Random String    4    [LOWER]
    Set To Dictionary    ${body}   nome  ${nome_rand}tester
    ${resposta}=     POST On Session    cinema    /auth/register    json=${body}    expected_status=${status_esperado}
    RETURN    ${resposta}

Cadastrar usuario valido e retornar credenciais
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    user.json
    ${body}=       Get From Dictionary    ${json}    usuario_valido
    ${password}=   Get From Dictionary    ${body}    password
    ${email_rand}=   Generate Random String    6    [LOWER]
    ${email}=      Set Variable    ${email_rand}@mail.com
    Set To Dictionary    ${body}    email    ${email}
    ${resposta}=     POST On Session    cinema    /auth/register    json=${body}    expected_status=${status_esperado}
    ${credenciais}=   Create Dictionary    email=${email}    password=${password}
    RETURN           ${resposta}    ${credenciais}

Cadastrar usuario duplicado
    [Arguments]    ${status_esperado}
    ${json}=      importar json estatico    user.json
    ${body}=      Get From Dictionary    ${json}    usuario_duplicado
    POST On Session    cinema    /auth/register    json=${body}    expected_status=any
    ${resposta}=  POST On Session    cinema    /auth/register    json=${body}    expected_status=${status_esperado}
    RETURN    ${resposta}
Cadastrar usuario faltando senha
    [Arguments]    ${status_esperado}
    ${json}=      importar json estatico    user.json
    ${body}=      Get From Dictionary    ${json}    usuario_falta
    ${resposta}=  POST On Session    cinema    /auth/register    json=${body}    expected_status=${status_esperado}
    RETURN    ${resposta}

Login com senha incorreta
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    user.json
    ${auth_body}=   Get From Dictionary    ${json}    usuario_valido
    ${password}=   Get From Dictionary   ${auth_body}    password
    ${email_rand}=   Generate Random String    6    [LOWER]
    Set To Dictionary   ${auth_body}    email    ${email_rand}@mail.com
    ${nome_rand}=    Generate Random String    8    [LOWER]
    Set To Dictionary   ${auth_body}    name     User ${nome_rand} 
    POST On Session    cinema    /auth/register    json=${auth_body}    expected_status=any
    # ---  LOGIN ---
    ${login_body}=   Create Dictionary    email=${email_rand}@mail.com    password=senhaincorreta
    ${resposta_login}=   POST On Session    cinema    /auth/login    json=${login_body}    expected_status=${status_esperado} 
    RETURN  ${resposta_login}

Obter dados do usuario
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   GET On Session    cinema    /auth/me    headers=${headers}    expected_status=200
    RETURN         ${resposta}

Obter dados do usuario sem token
    [Arguments]    ${status_esperado}
    ${resposta}=   GET On Session    cinema    /auth/me    expected_status=${status_esperado}
    RETURN         ${resposta}


Cadastrar adm
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    user.json
    ${body}=       Get From Dictionary    ${json}    usuario_adm
    ${password}=   Get From Dictionary    ${body}    password  
    ${email_rand}=   Generate Random String    6    [LOWER]
    ${email}=      Set Variable    ${email_rand}adm@mail.com
    Set To Dictionary    ${body}    email    ${email}
    ${nome_rand}=    Generate Random String    4    [LOWER]
    Set To Dictionary    ${body}    name     ${nome_rand}admtester 
    ${resposta}=     POST On Session    cinema    /setup/admin    json=${body}    expected_status=${status_esperado}
    ${credenciais}=   Create Dictionary    email=${email}    password=${password}
    RETURN           ${resposta}    ${credenciais}

Listar usuarios com token
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   GET On Session    cinema    /users    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}



Deletar usuário com token
    [Arguments]    ${token}    ${id_do_usuario}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   DELETE On Session    cinema    /users/${id_do_usuario}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}


Login com credenciais
     [Arguments]    ${email}    ${password}    ${status_esperado}
    ${body}=       Create Dictionary    email=${email}    password=${password}
    ${resposta}=   POST On Session    cinema    /auth/login    json=${body}    expected_status=${status_esperado}
    RETURN         ${resposta}

Atualizar usuário com token
    [Arguments]    ${token}    ${id_do_usuario}    ${novos_dados}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   PUT On Session    cinema    /users/${id_do_usuario}    json=${novos_dados}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}