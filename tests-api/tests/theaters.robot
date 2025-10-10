*** Settings ***
Documentation    casos te teste relacionados a salas
Resource    ../resources/libs/common.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***
CT-API-020: Listar todas as salas com sucesso
    [Tags]    GET   THEATERS   
    ${resp}=    Listar salas    200
    Conferência de lista de salas  ${resp.json()}

CT-API-021: Criar uma sala como adm
    [Tags]    POST   THEATERS   ADM
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${random_string}=    Generate Random String    4    [UPPER]
    ${nome_da_sala}=     Set Variable    Sala de Teste ${random_string}
    ${dados_da_sala}=    Create Dictionary
    ...                  name=${nome_da_sala}
    ...                  capacity=150
    ...                  type=standard
    ${resp_create}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    Conferência de sala criada    ${resp_create.json()}    ${dados_da_sala}