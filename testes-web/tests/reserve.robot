*** Settings ***
Documentation    cenarios de login
Library          Collections
Library          String
Library          Browser
Resource         resources/base.resource


Test Setup       start session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-FE-013: Selecionar e deselecionar um assento
    [Tags]    RESERVA    FELIZ
    ${user}    Create Dictionary    name=user normal    email=testuser@mail.com    password=senha123
    ir para pagina de login
    remover usuario do banco de dados    ${user}[email]
    inserir usuario no banco de dados    ${user}
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    ${subtotal_inicial}=    Capturar subtotal
    # retorna a parte estável do title, ex: "Fileira A, Assento 1"
    ${id_estavel_do_assento}=    Encontrar e clicar no primeiro assento disponível
    Sleep    1s
    ${subtotal_selecionado}=   Capturar subtotal
    Should Be True            ${subtotal_selecionado} > ${subtotal_inicial}

    #  seletor que busca por um botão cujo title COMEÇA COM (ˆ=) nosso ID estável
    ${seletor_estavel_do_assento}=    Set Variable    css=button[title^="${id_estavel_do_assento}"]
    Click    ${seletor_estavel_do_assento}
    Sleep    1s     #usei para simular um humano pois estava muito rápido e dava erros
    ${subtotal_final}=       Capturar subtotal
    Should Be Equal As Numbers    ${subtotal_final}    ${subtotal_inicial}