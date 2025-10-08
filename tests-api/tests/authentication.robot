*** Settings ***
Documentation    casos te teste de autenticação de usuarios
Resource    ../resources/libs/common.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***

CT-API-001: Cadastrar novo usuário com sucesso
    ${resp}=    Cadastrar usuario valido   201
    Conferência de cadastro    ${resp.json()}