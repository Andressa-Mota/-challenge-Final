*** Settings ***
Documentation    cenarios de login
Library    Collections


Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***
CT-FE-009: Visualizar página de administração com login de adm
    [Tags]    ADMIN   LOGIN   SUCESSO

    # Cria um usuário admin dinâmico e obtém suas credenciais atraves do banco de dados
    ${credenciais_adm}=    Cadastrar adm
    ir para pagina de login
    submeter formulario de login    ${credenciais_adm}
    Conferir mensagem na tela     Login realizado com sucesso!
    ir para pagina de adm
    Conferir mensagem na tela     Página Não Encontrada

CT-FE-010: Navegar na lista de filmes e ver detalhes
    [Tags]    FILMES LISTA

    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Wait For Elements State    css=.movie-info h1     visible    timeout=5s
    Get Text                   css=.movie-info h1    ==    ${titulo_clicado}

CT-FE-011: Visualizar detalhes do filme e sessões
    [Tags]    FILMES     SESSÕES
    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Wait For Elements State    css=.movie-info h1     visible    timeout=5s
    Get Text                   css=.movie-info h1    ==    ${titulo_clicado}