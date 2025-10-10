*** Settings ***
Documentation    cenarios de login
Library    Collections


Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***
CT-FE-012: Ir à seleção de lugares
    [Tags]     SESSÃO  LUGARES
    ir para pagina inicial
     ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    ${titulo_clicado}=    Selecionar a primeira sessão da lista
     Conferir mensagem na tela      Assentos Selecionados: