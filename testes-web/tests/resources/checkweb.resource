*** Settings ***
Documentation    Elementos e ações de registro de usuarios

Library    Browser
Resource   libs/env.resource

*** Keywords ***
Conferir mensagem na tela 
    [Arguments]    ${mensagem_esperada}
    ${seletor_da_notificacao}=    Set Variable    xpath=//*[contains(text(), "${mensagem_esperada}")]
    Wait For Elements State    ${seletor_da_notificacao}    visible    timeout=5s
   Get Text   ${seletor_da_notificacao}    ==    ${mensagem_esperada}

Conferir mensagem de validação de campo
    [Arguments]    ${seletor_do_campo}    ${mensagem_esperada}
    ${mensagem_real}=    Get Property    ${seletor_do_campo}    validationMessage
    Should Be Equal As Strings    ${mensagem_real}    ${mensagem_esperada}
    #Está keyword foi desenvolvida a partir do auxilio do colega da equie 5, testMasters, Mario.
    #Que desvendou como encontrar a mensagem através do validationMessage no input de password e disponibilizou seu trecho de código no grupo

Conferir pagina de login
    ${titulo_filmes_em_cartaz}=    Set Variable    css=.login-header h1
    Wait For Elements State        ${titulo_filmes_em_cartaz}    visible    timeout=5s
    Get Text    ${titulo_filmes_em_cartaz}        ==       Login


    