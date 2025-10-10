*** Settings ***
Documentation    cenarios de login
Library    Collections
Library    SeleniumLibrary
Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***
CT-FE-013: Selecionar e deselecionar um assento
    [Tags]    ASSENTOS    RESERVAS

    # ---------- ABRIR NAVEGADOR ----------
    SeleniumLibrary.OpenBrowser        ${BASE_URL}       chrome
    Maximize Browser Window

    # ---------- CADASTRAR NOVO USUÁRIO ----------
    ${random_email}=    Generate Random String    8    [LOWER]
    ${user}=    Create Dictionary
    ...    name=Tester123
    ...    email=${random_email}@test.com
    ...    password=senha123

    remover usuario do banco de dados    ${user}[email]

    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela    Conta criada com sucesso!

    # ---------- LOGIN ----------
    ir para pagina de login
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!

    # ---------- ACESSAR FILMES E SESSÃO ----------
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait Until Element Is Visible    css=.seats-container    timeout=10s

    # ---------- CAPTURAR SUBTOTAL INICIAL ----------
    ${seletor_subtotal}=    Set Variable    css=span.price
    ${subtotal_inicial_texto}=    Get Text    ${seletor_subtotal}
    ${subtotal_inicial_num}=     Extrair valor numerico do preco    ${subtotal_inicial_texto}

    # ---------- CLICAR NO PRIMEIRO ASSENTO DISPONÍVEL ----------
    ${seletor_assento}=    css=:nth-match(button.seat.available, 1)
    Wait Until Element Is Visible    ${seletor_assento}    timeout=10s
    Click Element    ${seletor_assento}

    # ---------- ESPERAR ATÉ QUE O ASSENTO FIQUE SELECIONADO ----------
    Wait Until Keyword Succeeds    5 times    1s
    ...    Element Attribute Should Contain    ${seletor_assento}    class    selected

    # ---------- VALIDAR ALTERAÇÃO DO PREÇO ----------
    ${subtotal_apos_clique_texto}=    Get Text    ${seletor_subtotal}
    ${subtotal_apos_clique_num}=      Extrair valor numerico do preco    ${subtotal_apos_clique_texto}
    Should Be True    ${subtotal_apos_clique_num} > ${subtotal_inicial_num}

    # ---------- DESELECIONAR O MESMO ASSENTO ----------
    Click Element    ${seletor_assento}

    # ---------- ESPERAR ATÉ QUE O ASSENTO VOLTE AO ESTADO ORIGINAL ----------
    Wait Until Keyword Succeeds    5 times    1s
    ...    Element Attribute Should Contain    ${seletor_assento}    class    available
    Wait Until Keyword Succeeds    5 times    1s
    ...    Element Attribute Should Not Contain    ${seletor_assento}    class    selected

    # ---------- VALIDAR RETORNO DO PREÇO ----------
    ${subtotal_final_texto}=    Get Text    ${seletor_subtotal}
    ${subtotal_final_num}=      Extrair valor numerico do preco    ${subtotal_final_texto}
    Should Be Equal As Numbers  ${subtotal_final_num}    ${subtotal_inicial_num}

    # ---------- FECHAR NAVEGADOR ----------
    Close Browser

