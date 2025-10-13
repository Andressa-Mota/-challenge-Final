*** Settings ***
Documentation     Elementos e ações de reservas
Library           Browser
Library           String
Resource          base.resource

*** Keywords ***
# Keyword para extrair o número de um texto de preço
Extrair valor numerico do preco
    [Arguments]    ${texto_preco}
    ${valor_string}=    Replace String    ${texto_preco}    R$    ${EMPTY}
    ${valor_string}=    Replace String    ${valor_string}    ,     .
    ${valor_numerico}=    Convert To Number    ${valor_string}
    RETURN    ${valor_numerico}

Encontrar e clicar no primeiro assento disponível
    ${seletor_do_primeiro_disponivel}=    Set Variable    css=:nth-match(button.seat.available, 1)
    Wait For Elements State    ${seletor_do_primeiro_disponivel}    visible    timeout=5s
    ${titulo_completo}=    Get Attribute    ${seletor_do_primeiro_disponivel}    title
    Click    ${seletor_do_primeiro_disponivel}
    @{partes_do_titulo}=    Split String    ${titulo_completo}    - Status:
    ${identificador_estavel}=    Set Variable    ${partes_do_titulo}[0]
    RETURN    ${identificador_estavel}

Capturar subtotal

    ${seletor_do_preco}=    Set Variable    css=span.price
    Wait For Elements State    ${seletor_do_preco}    visible    timeout=5s
    ${texto_do_preco}=     Get Text    ${seletor_do_preco}
    IF    '${texto_do_preco}' == ''
        ${texto_do_preco}=    Get Property    ${seletor_do_preco}    textContent
    END
    ${valor_numerico}=     Extrair valor numerico do preco    ${texto_do_preco}
    RETURN                 ${valor_numerico}

Verificar se o clique em elemento desabilitado falha
    [Arguments]    ${seletor_do_elemento}
    ${status}    ${mensagem_de_erro}=    Run Keyword And Ignore Error    Click    ${seletor_do_elemento}
    Should Be Equal As Strings    ${status}    FAIL
    Should Contain    ${mensagem_de_erro}    element is not enabled

Selecionar método de pagamento
    [Arguments]    ${metodo}
    ${seletor}=    Set Variable    css=div.payment-method:has-text("${metodo}")
    Wait For Elements State    ${seletor}    visible    timeout=5s
    Click    ${seletor}

Capturar código da reserva
    ${seletor_codigo}=    Set Variable    xpath=//span[text()='Código da Reserva:']/following-sibling::span
    Wait For Elements State    ${seletor_codigo}    visible    timeout=5s
    ${codigo}=               Get Text    ${seletor_codigo}
    RETURN                   ${codigo}

