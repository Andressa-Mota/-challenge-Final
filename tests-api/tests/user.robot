*** Settings ***
Documentation    casos te teste de autenticação de usuarios
Resource    ../resources/libs/common.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***

CT-API-001: Cadastrar novo usuário com sucesso
     [Tags]    POST    AUTH
    ${resp}=    Cadastrar usuario valido   201
    Conferência de cadastro    ${resp.json()}
CT-API-002: Cadastrar com email duplicado 
    [Tags]    POST    AUTH
     ${resp}=    Cadastrar usuario duplicado    400
    Conferência de erro    ${resp.json()}   User already exists

CT-API-003: Cadastrar com dados em falta
     [Tags]    POST    AUTH
    ${resp}=    Cadastrar usuario faltando senha   400
    Conferência de erro    ${resp.json()}   Validation failed

CT-API-004: Login com credenciais validas
    [Tags]    POST    AUT/LOGIN
    ${resp}=     Cadastrar usuario e fazer login    200
    Conferência de login    ${resp.json()}

CT-API-005: Login com senha incorreta
         [Tags]    POST    AUT/LOGIN
      ${resp}=   Login com senha incorreta    400
      Conferência de erro    ${resp.json()}   	Invalid credentials

CT-API-006: Obter dados do usuário
   [Tags]    POST    AUT/ME
   ${resp_login}=  Cadastrar usuario e fazer login    200
    ${token}=          Set Variable    ${resp_login.json()['data']['token']}
    ${resp_perfil}=    Obter dados do usuario    ${token}
    Conferência de dados do usuário    ${resp_perfil.json()}

CT-API-007: Obter dados do usuário sem token
    [Tags]    GET    AUT/ME
    ${resp}=     Obter dados do usuario sem token    401
    Conferência de erro    ${resp.json()}   		Not authorized to access this route

CT-API-008: Listar usuários como adm
    [Tags]    GET    USERS
    ${resp_cadastro}    ${credenciais}=    Cadastrar adm    201
    Conferência de cadastro adm    ${resp_cadastro.json()}
     ${resp_login}=  Login com credenciais    ${credenciais['email']}    ${credenciais['password']}    200
     ${token}=          Set Variable    ${resp_login.json()['data']['token']}
    ${resp_lista}=     Listar usuarios com token    ${token}    200
     Conferência de lista de usuário   ${resp_lista.json()}

CT-API-009: Listar usuários como user comum
    [Tags]    GET    USERS
    ${resp_cadastro}    ${credenciais}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login}=  Login com credenciais    ${credenciais['email']}    ${credenciais['password']}    200
    ${token_comum}=    Set Variable    ${resp_login.json()['data']['token']}
    ${resp_lista}=     Listar usuarios com token    ${token_comum}    403
    Conferência de erro    ${resp_lista.json()}   	User role user is not authorized to access this route

CT-API-010: Deletar um usuário 
    [Tags]    DELETE   USERS   
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${id_usuario_alvo}=     Set Variable    ${resp_cadastro_user.json()['data']['_id']}
    ${resp_delete}=  Deletar usuário com token    ${token_adm}    ${id_usuario_alvo}    200
    Conferência de delete com seucesso    ${resp_delete.json()}    User deleted successfully

CT-API-011: Atualizar um usuário 
    [Tags]    PUT   USERS   ADMIN
   ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=       Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${id_usuario_alvo}=     Set Variable    ${resp_cadastro_user.json()['data']['_id']}
    ${nome_aleatorio}=        Generate Random String    8    [UPPER]
    ${nome_completo_novo}=    Set Variable    Usuario Atualizado ${nome_aleatorio}
    ${novos_dados}=           Create Dictionary    name=${nome_completo_novo}
    ${resp_update}=           Atualizar usuário com token    ${token_adm}    ${id_usuario_alvo}    ${novos_dados}    200
    Conferência de atualização de usuário    ${resp_update.json()}    ${nome_completo_novo}