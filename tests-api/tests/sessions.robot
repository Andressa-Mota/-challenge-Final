*** Settings ***
Documentation    casos de teste relacionados a filmes
Resource    ../resources/libs/common.resource
Resource    ../resources/libs/pages/films-page.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***
CT-API-022: Listar todas as sessoes 
    [Tags]    GET   SESSIONS   
    ${resp}=    Listar sessoes    200
    Conferência de lista de sessoes    ${resp.json()}

CT-API-023: Criar uma nova sessão como adm
    [Tags]    POST   SESSIONS   ADM

    #Obtendo  o token de um administrador 
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}

    # criando um FILME para a sessão 
    ${titulo_filme}=        Set Variable    Filme em Cartaz Teste
    @{generos}=             Create List    Ação
    ${dados_do_filme}=      Create Dictionary    title=${titulo_filme}    synopsis=Sinopse.    director=Diretor    genres=${generos}    duration=140    classification=12    releaseDate=2025-11-15
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}

    # Criando uma SALA (THEATER) para a sessão 
    ${dados_da_sala}=       Create Dictionary    name=Sala VIP Teste    capacity=50    type=IMAX
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}

    # Dados da SESSÃO 
    ${dados_da_sessao}=     Create Dictionary
    ...                     movie=${id_do_filme}
    ...                     theater=${id_da_sala}
    ...                     datetime=2025-11-15T20:00:00.000Z
    ...                     fullPrice=50
    ...                     halfPrice=25

    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    # Conferir se a sessão foi criada com os dados corretos 
    Conferência de sessao criada    ${resp_create_sessao.json()}    ${dados_da_sessao}
    #Seguir os passos comentados garante um caso de testes independente e completo

CT-API-024: Criar uma nova sessão como usuario comum
    [Tags]    POST   SESSIONS   
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=     Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    @{generos_para_filme}=    Create List    Ação
    ${dados_do_filme}=      Create Dictionary    title=Filme Teste    synopsis=Sinopse    director=Diretor    genres=${generos_para_filme}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${dados_da_sala}=       Create Dictionary    name=Sala Teste    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=     Login com credenciais    ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${dados_da_sessao}=     Create Dictionary
    ...                     movie=${id_do_filme}
    ...                     theater=${id_da_sala}
    ...                     datetime=2025-10-10T22:00:00.000Z
    ...                     fullPrice=35
    ...                     halfPrice=17.50

    ${resp_create_sessao}=  Criar sessao com token    ${token_comum}    ${dados_da_sessao}    403
    Conferência de erro    ${resp_create_sessao.json()}     User role user is not authorized to access this route