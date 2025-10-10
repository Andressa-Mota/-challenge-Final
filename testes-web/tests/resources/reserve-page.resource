*** Settings ***
Documentation    Elementos e ações de reservas

Library    Browser
Library    String
Resource   libs/env.resource

*** Keywords ***
# Keyword para extrair o número de um texto de preço
Extrair valor numerico do preco
    [Arguments]    ${texto_preco}
    ${valor_string}=    Replace String    ${texto_preco}    R$    ${EMPTY}
    ${valor_string}=    Replace String    ${valor_string}    ,    .
    ${valor_numerico}=    Convert To Number    ${valor_string}
    RETURN    ${valor_numerico}

# Keyword para encontrar, clicar e retornar o primeiro assento livre
Encontrar e clicar no primeiro assento disponível
    [Documentation]    Encontra o primeiro assento com a classe 'available',
    ...                clica nele usando JavaScript e retorna o seletor.

    ${seletor_assento}=    Set Variable    css=:nth-match(button.seat.available, 1)

    Wait For Elements State    ${seletor_assento}    visible    timeout=5s

    # CORREÇÃO DEFINITIVA: Usamos JavaScript para garantir que o clique aconteça e
    # dispare todos os eventos da página corretamente.
   Evaluate JavaScript    ${seletor_assento}    element => element.click()
    RETURN    ${seletor_assento}