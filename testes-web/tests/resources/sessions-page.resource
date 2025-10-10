*** Settings ***
Documentation    Elementos e ações de sessões

Library    Browser
Resource   libs/env.resource

*** Keywords ***
Selecionar a primeira sessão da lista
    ${seletor_primeiro_botao}=    Set Variable    css=:nth-match(.session-card, 1) >> text=Selecionar Assentos
    Wait For Elements State    ${seletor_primeiro_botao}    visible    timeout=5s
    Click                      ${seletor_primeiro_botao}
   