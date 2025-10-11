*** Settings ***
Documentation    Elementos e ações de login

Library    Browser
Resource   libs/env.resource

*** Keywords ***

ir para pagina de login

    Go To    ${BASE_URL}/login
   ${titulo_filmes_em_cartaz}=    Set Variable    css=.login-header h1
    Wait For Elements State        ${titulo_filmes_em_cartaz}    visible    timeout=5s
    Get Text    ${titulo_filmes_em_cartaz}        ==       Login


submeter formulario de login
    [Arguments]    ${user}
    Fill Text    css=input[placeholder$='mail']    ${user}[email] 
    Fill Text    css=input[placeholder$='senha']    ${user}[password] 

    Click   css=button >> text=Entrar
    Wait For Function    () => window.localStorage.getItem('token')

fazer logout
    Click   css=button >> text= Sair

ir para pagina de reservas

    Go To    ${BASE_URL}/reservations
ir para perfil
    Click   css=a >> text= Perfil

Atualizar nome completo e salvar
    [Arguments]    ${novo_nome}
    ${seletor_nome_completo}=    Set Variable    css=input#name
    Clear Text    ${seletor_nome_completo}
    Fill Text     ${seletor_nome_completo}    ${novo_nome}
    Click   css=button >> text= Salvar Alterações

clicar ok
    Click   css=button >> text=OK