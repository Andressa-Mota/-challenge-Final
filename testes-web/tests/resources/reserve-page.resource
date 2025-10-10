*** Settings ***
Documentation    Elementos e ações de reservas

Library    Browser
Library    String
Resource   base.resource

*** Keywords ***
# Keyword para extrair o número de um texto de preço
Extrair valor numerico do preco
    [Arguments]    ${texto_preco}
    ${valor_string}=    Replace String    ${texto_preco}    R$    ${EMPTY}
    ${valor_string}=    Replace String    ${valor_string}    ,    .
    ${valor_numerico}=    Convert To Number    ${valor_string}
    RETURN    ${valor_numerico}


Encontrar e clicar no primeiro assento disponível
    ${seletor_do_primeiro_disponivel}=    Set Variable    css=:nth-match(button.seat.available, 1)
    Wait For Elements State    ${seletor_do_primeiro_disponivel}    visible    timeout=5s

    # Pega o atributo "title" completo
    ${titulo_completo}=    Get Attribute    ${seletor_do_primeiro_disponivel}    title

    Click    ${seletor_do_primeiro_disponivel}
    @{partes_do_titulo}=    Split String    ${titulo_completo}    - Status:
    ${identificador_estavel}=    Set Variable    ${partes_do_titulo}[0]
    RETURN    ${identificador_estavel}



Capturar subtotal
    [Documentation]    Aguarda o subtotal estar visível e retorna o valor numérico.

    # Usamos o seletor que descobrimos juntos para o preço total
    ${seletor_do_preco}=    Set Variable    css=span.price

    Wait For Elements State    ${seletor_do_preco}    visible    timeout=5s
    ${texto_do_preco}=     Get Text    ${seletor_do_preco}

    # Se Get Text falhar em pegar o valor, tenta com Get Property (torna mais robusto)
    IF    '${texto_do_preco}' == ''
        ${texto_do_preco}=    Get Property    ${seletor_do_preco}    textContent
    END

    # Usa a outra keyword auxiliar para extrair apenas o número do texto (ex: "R$ 50,00" -> 50.00)
    ${valor_numerico}=     Extrair valor numerico do preco    ${texto_do_preco}

    RETURN              ${valor_numerico}