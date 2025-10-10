*** Settings ***
Documentation    casos de teste relacionados a filmes
Resource    ../resources/libs/common.resource
Resource    ../resources/libs/pages/films-page.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***
CT-API-012: Listar filmes 
    [Tags]    GET   MOVIES   
    ${resp}=    Listar filmes   200
    Conferência de lista de filmes    ${resp.json()}

CT-API-013: Obter detalhes de um filme
    [Tags]    GET   MOVIES   ID
    ${resp_lista}=      Listar filmes    200
    ${id_primeiro_filme}=  Set Variable    ${resp_lista.json()['data'][0]['_id']}
    ${resp_filme}=      Obter filme por ID    ${id_primeiro_filme}    200
    Conferência de filme unico    ${resp_filme.json()}    ${id_primeiro_filme}

CT-API-014: Criar um novo filme como adm
    [Tags]    POST   MOVIES   ADM
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    # Dados do filme
    ${random_string}=         Generate Random String    8    [UPPER]
    ${titulo_filme}=          Set Variable    Filme de Teste ${random_string}
    @{generos}=               Create List    Ação    Ficção Científica
    ${dados_do_filme}=        Create Dictionary
    ...                       title=${titulo_filme}
    ...                       synopsis=Sinopse de um filme.
    ...                       director=Tester Diretor
    ...                       genres=${generos}
    ...                       duration=120
    ...                       classification=Livre
    ...                       poster=poster_teste.jpg
    ...                       releaseDate=2025-10-09
    ${resp_create}=    Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    Conferência de filme criado    ${resp_create.json()}    ${dados_do_filme}

CT-API-015: Usuário comum não deve criar um novo filme
    [Tags]    POST   MOVIES   
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=     Login com credenciais    ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=         Set Variable    ${resp_login_user.json()['data']['token']}
    ${random_string}=    Generate Random String    8    [UPPER]
    ${titulo_filme}=     Set Variable    Filme Proibido ${random_string}
    @{generos}=          Create List    Drama
    ${dados_do_filme}=   Create Dictionary
    ...                  title=${titulo_filme}
    ...                  synopsis=Um usuário comum tenta criar este filme.
    ...                  director=Diretor Comum
    ...                  genres=${generos}
    ...                  duration=90
    ...                  classification=12
    ...                  poster=poster_proibido.jpg
    ...                  releaseDate=2025-10-10
    ${resp_create}=    Criar filme com token    ${token_comum}    ${dados_do_filme}    403
    Conferência de erro    ${resp_create.json()}    User role user is not authorized to access this route

CT-API-016: Administrador deve atualizar um filme
    [Tags]    PUT   MOVIES   ADM
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    #A próxima linha foi criada com auxílio de IA, pois eu não entendia o erro de não encontrar o token na resposta, só após pedir queela analisasse o corpoda resposta
    #pude compreender que token, e outros itens, se encontravam encapsulados dentro de "data" e que é necessário informar esse caminho antes para encontrar os dados retornados no corpo da resposta
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${titulo_original}=       Set Variable    Filme Original para Update
    @{generos_originais}=     Create List    Ação
    ${filme_original_data}=   Create Dictionary
    ...                       title=${titulo_original}
    ...                       synopsis=Sinopse original.
    ...                       director=Diretor Original
    ...                       genres=${generos_originais}
    ...                       duration=150                     
    ...                       classification=Livre                
    ...                       releaseDate=2025-01-01              
    ${resp_create}=           Criar filme com token    ${token_adm}    ${filme_original_data}    201
    ${id_filme_alvo}=         Set Variable    ${resp_create.json()['data']['_id']}
    ${novo_titulo}=           Set Variable    Filme atualizado com Sucesso
    ${dados_para_update}=     Create Dictionary    title=${novo_titulo}
    ${resp_update}=           Atualizar filme com token    ${token_adm}    ${id_filme_alvo}    ${dados_para_update}    200
    Conferência de atualização de filme    ${resp_update.json()}    ${dados_para_update}

CT-API-017: Deletar um filme como adm
    [Tags]    DELETE   MOVIES   ADM

    # cadastrar como adm, fazer login como adm e obter suas credenciais
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}

    #  Criar um filme novo 
    ${titulo_filme}=          Set Variable    Filme para Deletar
    @{generos}=               Create List    Suspense
    ${dados_do_filme}=        Create Dictionary
    ...                       title=${titulo_filme}
    ...                       synopsis=Sinopse de um filme que será apagado.
    ...                       director=Diretor tester
    ...                       genres=${generos}
    ...                       duration=100
    ...                       classification=14
    ...                       releaseDate=2024-01-01

    ${resp_create}=           Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_filme_alvo}=         Set Variable    ${resp_create.json()['data']['_id']}

    #  Usar o token do adm para deletar o filme 
    ${resp_delete}=    Deletar filme com token    ${token_adm}    ${id_filme_alvo}    200

    #  Conferir se a API retornou a mensagem de sucesso 
    Conferência de delete com seucesso    ${resp_delete.json()}    Movie removed
#tanto nessa quanto em todos os casos de teste, buscou-se mantê-los independentes, por esse motivo todos seguem esse fluxo
#onde todas as vezes é criado um novo usuário, filme, ou algo que será utilizxado, antes de fazer uso de suas credencias ou fazer ações como a deletar, criar e atualizar
#D
CT-API-018: Deletar um filme como usuario comum
    [Tags]    DELETE   MOVIES   
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${titulo_filme}=       Set Variable    Filme Alvo para Deleção Proibida
    @{generos}=            Create List    Aventura
    ${dados_do_filme}=     Create Dictionary
    ...                    title=${titulo_filme}
    ...                    synopsis=Filme que um usuário comum tentará apagar.
    ...                    director=Diretor X
    ...                    genres=${generos}
    ...                    duration=110
    ...                    classification=10
    ...                    releaseDate=2023-10-10
    ${resp_create}=        Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_filme_alvo}=      Set Variable    ${resp_create.json()['data']['_id']}
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=     Login com credenciais    ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${resp_delete}=    Deletar filme com token    ${token_comum}    ${id_filme_alvo}    403
    Conferência de erro    ${resp_delete.json()}    User role user is not authorized to access this route

CT-API-019: Deletar filme com ID inexistente
    [Tags]    DELETE   MOVIES   
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    #A linha seguinte teve auxilio de IA, pois havia um erro persistente e eu não percebi sozinha que o ID tem um padrão específico
    #deve seguir uma quantidade de caracteres e possuir tmb caracteres especificos
    ${id_inexistente}=    Set Variable    1234567890abcdef12345678
    ${resp_delete}=       Deletar filme com token    ${token_adm}    ${id_inexistente}    404
    Conferência de erro    ${resp_delete.json()}    	Movie not found