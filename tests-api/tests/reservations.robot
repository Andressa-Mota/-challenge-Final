*** Settings ***
Documentation    casos de teste relacionados a filmes
Resource    ../resources/libs/common.resource
Resource    ../resources/libs/pages/films-page.resource

#executa antes de cada teste
Test Setup    iniciar sessao

*** Test Cases ***

CT-API-025: Listar reservas
    [Tags]    GET   RESERVATIONS   

    # criar Adm,filme, sala, sessão
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais  ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${dados_do_filme}=      Create Dictionary    title=Filme para Reservar    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${random_string}=       Generate Random String    4    [UPPER]
    ${nome_da_sala}=        Set Variable    Sala para Reservar ${random_string}
    ${dados_da_sala}=       Create Dictionary    name=${nome_da_sala}    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-12-25T20:00:00.000Z    fullPrice=40    halfPrice=20
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}

    # criar Usuário comum e faz uma reserva 
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=      Login com credenciais   ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}

    # Encontrar um assento disponível na sessão que o adm criou
    ${assentos_da_sessao}=    Set Variable    ${resp_create_sessao.json()['data']['seats']}
    ${assento_disponivel}=    Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_disponivel}    type=full
    @{assentos_para_reservar}=    Create List    ${assento_disponivel}
    ${dados_reserva}=         Create Dictionary    session=${id_da_sessao}    seats=${assentos_para_reservar}
    Criar reserva com token    ${token_comum}    ${dados_reserva}    201 
    # Usuário comum lista suas próprias reservas 
    ${resp_lista_reservas}=   Listar minhas reservas    ${token_comum}    200

    #VALIDAÇÃO:
    Conferência de lista de reservas    ${resp_lista_reservas.json()}    ${id_da_sessao}

CT-API-026: Criar uma nova reserva com sucesso
    [Tags]    POST   RESERVATIONS   
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${dados_do_filme}=      Create Dictionary    title=Filme para Reservar    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
      ${random_string}=       Generate Random String    4    [UPPER]
    ${nome_da_sala}=        Set Variable    Sala para Reservar ${random_string}
    ${dados_da_sala}=       Create Dictionary    name=${nome_da_sala}    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-12-25T20:00:00.000Z    fullPrice=40    halfPrice=20
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}

    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=      Login com credenciais   ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${id_do_usuario}=        Set Variable    ${resp_login_user.json()['data']['_id']}

    ${assento_disponivel}=    Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_disponivel}    type=full
    @{assentos_para_reservar}=     Create List    ${assento_disponivel}
    ${dados_reserva}=         Create Dictionary
    ...                       session=${id_da_sessao}
    ...                       seats=${assentos_para_reservar}
    ...                       paymentMethod=credit_card

    ${resp_reserva}=    Criar reserva com token    ${token_comum}    ${dados_reserva}    201

  
    Conferência de reserva criada    ${resp_reserva.json()}    ${id_do_usuario}    ${id_da_sessao}

CT-API-027: Criar reserva com assento já ocupado
    [Tags]    POST   RESERVATIONS   

    #  Adm cria o ambiente 
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${dados_do_filme}=      Create Dictionary    title=Filme Disputado    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${dados_da_sala}=       Create Dictionary    name=Sala Disputada    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-12-31T22:00:00.000Z    fullPrice=50    halfPrice=25
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}

    #  Usuário 1  reserva o primeiro assento disponível 
    ${resp_cadastro_user1}    ${credenciais_user1}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user1}=     Login com credenciais   ${credenciais_user1['email']}    ${credenciais_user1['password']}    200
    ${token_user1}=          Set Variable    ${resp_login_user1.json()['data']['token']}
    ${assento_a_ocupar}=     Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_a_ocupar}    type=full
    @{lista_assento_ocupado}=     Create List    ${assento_a_ocupar}
    ${dados_reserva1}=       Create Dictionary    session=${id_da_sessao}    seats=${lista_assento_ocupado}    paymentMethod=credit_card
    Criar reserva com token    ${token_user1}    ${dados_reserva1}    201

    #  Usuário 2  é criado e obtém seu token 
    ${resp_cadastro_user2}    ${credenciais_user2}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user2}=     Login com credenciais   ${credenciais_user2['email']}    ${credenciais_user2['password']}    200
    ${token_user2}=          Set Variable    ${resp_login_user2.json()['data']['token']}

    #  Usuário 2 tenta reservar o MESMO assento, esperando um erro 400 
    ${dados_reserva2}=       Create Dictionary    session=${id_da_sessao}    seats=${lista_assento_ocupado}    paymentMethod=credit_card
    ${resp_reserva2}=        Criar reserva com token    ${token_user2}    ${dados_reserva2}    400

    # Conferir a mensagem de erro de assento não disponível 
    ${nome_do_assento}=      Set Variable    ${assento_a_ocupar['row']}${assento_a_ocupar['number']}
    Conferência de erro    ${resp_reserva2.json()}    The following seats are not available: ${nome_do_assento}
    #tanto nessa quanto em todos os casos de teste, buscou-se mantê-los independentes, por esse motivo todos seguem esse fluxo
#onde todas as vezes é criado um novo usuário, filme, ou algo que será utilizado, antes de fazer uso de suas credencias ou fazer ações como a deletar, criar e atualizar

CT-API-028: Listar todas as reservas como adm
    [Tags]    GET   RESERVATIONS   ADM

    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${dados_do_filme}=      Create Dictionary    title=Filme para Lista Admin    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${dados_da_sala}=       Create Dictionary    name=Sala para Lista Admin    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-11-11T19:00:00.000Z    fullPrice=30    halfPrice=15
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}

    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=      Login com credenciais    ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${assento_disponivel}=    Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_disponivel}    type=full
    @{assentos_para_reservar}=     Create List    ${assento_disponivel}
    ${dados_reserva}=         Create Dictionary    session=${id_da_sessao}    seats=${assentos_para_reservar}    paymentMethod=credit_card
    Criar reserva com token    ${token_comum}    ${dados_reserva}    201

    ${resp_lista_geral}=   Listar todas as reservas com token    ${token_adm}    200
    Conferência de lista geral de reservas    ${resp_lista_geral.json()}

CT-API-029: Deletar uma reserva
    [Tags]    DELETE   RESERVATIONS   ADM

    # Admin cria o ambiente 
    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=      Login com credenciais    ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${random_filme}=        Generate Random String    4    [UPPER]
    ${titulo_filme}=        Set Variable    Filme para Cancelar ${random_filme}
    ${dados_do_filme}=      Create Dictionary    title=${titulo_filme}    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${random_sala}=         Generate Random String    4    [UPPER]
    ${nome_da_sala}=        Set Variable    Sala para Cancelar ${random_sala}
    ${dados_da_sala}=       Create Dictionary    name=${nome_da_sala}    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-11-20T21:00:00.000Z    fullPrice=30    halfPrice=15
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}

    #  Usuário comum faz uma reserva 
    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=      Login com credenciais    ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${assento_disponivel}=    Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_disponivel}    type=full
    @{assentos_para_reservar}=     Create List    ${assento_disponivel}
    ${dados_reserva}=         Create Dictionary    session=${id_da_sessao}    seats=${assentos_para_reservar}    paymentMethod=credit_card
    ${resp_reserva}=          Criar reserva com token    ${token_comum}    ${dados_reserva}    201
    ${id_da_reserva_alvo}=    Set Variable    ${resp_reserva.json()['data']['_id']}

    #  Admm deleta a reserva criada pelo usuário comum
    ${resp_delete}=    Deletar reserva com token    ${token_adm}    ${id_da_reserva_alvo}    200

    # Conferir se a API retornou a mensagem de sucesso 
    Conferência de sucesso   ${resp_delete.json()}    Reservation removed
    #Seguindo cada um desses passos temos o ciclo de vida completo de uma sessão em um caso de teste totalmente funcional, completo e independente

CT-API-030: Atualizar o estado de uma reserva
    [Tags]    PUT   RESERVATIONS   ADM

    ${resp_cadastro_adm}    ${credenciais_adm}=    Cadastrar adm    201
    ${resp_login_adm}=     Login com credenciais   ${credenciais_adm['email']}    ${credenciais_adm['password']}    200
    ${token_adm}=           Set Variable    ${resp_login_adm.json()['data']['token']}
    ${dados_do_filme}=      Create Dictionary    title=Filme para Atualizar Reserva    synopsis=Sinopse    director=Diretor    genres=@{EMPTY}    duration=120    classification=Livre    releaseDate=2025-10-10
    ${resp_create_filme}=   Criar filme com token    ${token_adm}    ${dados_do_filme}    201
    ${id_do_filme}=         Set Variable    ${resp_create_filme.json()['data']['_id']}
    ${dados_da_sala}=       Create Dictionary    name=Sala para Atualizar Reserva    capacity=100    type=standard
    ${resp_create_sala}=    Criar sala com token    ${token_adm}    ${dados_da_sala}    201
    ${id_da_sala}=          Set Variable    ${resp_create_sala.json()['data']['_id']}
    ${dados_da_sessao}=     Create Dictionary    movie=${id_do_filme}    theater=${id_da_sala}    datetime=2025-12-01T20:00:00.000Z    fullPrice=30    halfPrice=15
    ${resp_create_sessao}=  Criar sessao com token    ${token_adm}    ${dados_da_sessao}    201
    ${id_da_sessao}=        Set Variable    ${resp_create_sessao.json()['data']['_id']}
    ${assentos_da_sessao}=  Set Variable    ${resp_create_sessao.json()['data']['seats']}

    ${resp_cadastro_user}    ${credenciais_user}=    Cadastrar usuario valido e retornar credenciais    201
    ${resp_login_user}=     Login com credenciais   ${credenciais_user['email']}    ${credenciais_user['password']}    200
    ${token_comum}=          Set Variable    ${resp_login_user.json()['data']['token']}
    ${assento_disponivel}=    Encontrar primeiro assento disponível    ${assentos_da_sessao}
    Set To Dictionary        ${assento_disponivel}    type=full
    @{assentos_para_reservar}=     Create List    ${assento_disponivel}
    ${dados_reserva}=         Create Dictionary    session=${id_da_sessao}    seats=${assentos_para_reservar}    paymentMethod=credit_card
    ${resp_reserva}=          Criar reserva com token    ${token_comum}    ${dados_reserva}    201
    ${id_da_reserva_alvo}=    Set Variable    ${resp_reserva.json()['data']['_id']}

    ${novo_status}=       Set Variable    cancelled
    ${dados_update}=      Create Dictionary    status=${novo_status}
    ${resp_update}=       Atualizar reserva com token    ${token_adm}    ${id_da_reserva_alvo}    ${dados_update}    200
    Conferência de atualização de reserva    ${resp_update.json()}    ${novo_status}