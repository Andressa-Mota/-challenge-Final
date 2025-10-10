*** Settings ***

Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           RequestsLibrary
Resource          env.resource
Resource          pages/user-page.resource


*** Keywords ***
Conferência de cadastro
    [Arguments]    ${response}
    #A próxima linha foi criada com auxílio de IA, pois eu não entendia o erro de não encontrar o _id na resposta, só após pedir queela analisasse o corpoda resposta
    #pude compreender que _id, e outros itens, se encontravam encapsulados dentro de "data" e que é necessário informar esse caminho antes para encontrar os dados retornados no corpo da resposta
    Dictionary Should Contain Key    ${response['data']}    _id  

Conferência de cadastro adm
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    role 
    Should Be Equal As Strings    ${response['data']['role']}    admin 
Conferência de erro
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Contain    ${response['message']}    ${mensagem_esperada}

Conferência de login
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response['data']}    _id
    Dictionary Should Contain Key    ${response['data']}    token

Conferência de dados do usuário
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response['data']}    _id
    Dictionary Should Contain Key    ${response['data']}    name
    Dictionary Should Contain Key    ${response['data']}    email
    Dictionary Should Contain Key    ${response['data']}    role
    ...    
Conferência de lista de usuário
    [Arguments]    ${response}
     Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${quantidade}=    Get Length    ${response['data']} 
    Should Be True    ${quantidade} > 0

Conferência de sucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Be Equal As Strings    ${response['message']}    ${mensagem_esperada}

Conferência de delete com seucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key       ${response}    message
    Should Be Equal As Strings      ${response['message']}    ${mensagem_esperada}

Conferência de atualização de usuário
    [Arguments]    ${response}    ${nome_esperado}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${dados_usuario}=    Set Variable    ${response['data']}
    Should Be Equal As Strings       ${dados_usuario['name']}    ${nome_esperado}
    Dictionary Should Contain Key    ${dados_usuario}    _id
    Dictionary Should Contain Key    ${dados_usuario}    email

Conferência de lista de filmes
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response}    count
    Dictionary Should Contain Key    ${response}    pagination
    ${lista_filmes}=    Set Variable    ${response['data']}
    ${quantidade}=      Get Length    ${lista_filmes}
    Should Be True      ${quantidade} > 0

Conferência de filme unico
    [Arguments]    ${response}    ${id_esperado}
    Dictionary Should Contain Key   ${response['data']}    _id
    Dictionary Should Contain Key    ${response['data']}    title
    Dictionary Should Contain Key   ${response['data']}    director
    Should Be Equal As Strings    ${response['data']['_id']}    ${id_esperado}

Conferência de filme criado
    [Arguments]    ${response}    ${dados_enviados}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${filme_criado}=    Set Variable    ${response['data']}
    Dictionary Should Contain Key    ${filme_criado}    _id
    Dictionary Should Contain Key    ${filme_criado}    title
    Should Be Equal As Strings       ${filme_criado['title']}    ${dados_enviados['title']}

Conferência de atualização de filme
    [Arguments]    ${response}    ${dados_enviados}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${filme_atualizado}=    Set Variable    ${response['data']}
    Dictionary Should Contain Key    ${filme_atualizado}    _id
    Dictionary Should Contain Key    ${filme_atualizado}    title
    Should Be Equal As Strings       ${filme_atualizado['title']}    ${dados_enviados['title']}

Conferência de lista de salas
    [Arguments]    ${response}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response}    count
    ${lista_salas}=    Set Variable    ${response['data']}
    ${quantidade}=      Get Length    ${lista_salas}
    Should Be True      ${quantidade} > 0

Conferência de sala criada
    [Arguments]    ${response}    ${dados_enviados}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${sala_criada}=    Set Variable    ${response['data']}
    Dictionary Should Contain Key    ${sala_criada}    _id
    Dictionary Should Contain Key    ${sala_criada}    name
    Dictionary Should Contain Key    ${sala_criada}    capacity
    Dictionary Should Contain Key    ${sala_criada}    type
    Should Be Equal As Strings       ${sala_criada['name']}    ${dados_enviados['name']}

Conferência de lista de sessoes
    [Arguments]    ${response}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response}    count
    Dictionary Should Contain Key    ${response}    pagination 
    ${lista_sessoes}=    Set Variable    ${response['data']}
    ${quantidade}=       Get Length    ${lista_sessoes}
    Should Be True       ${quantidade} > 0

Conferência de sessao criada
    [Arguments]    ${response}    ${dados_enviados}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${sessao_criada}=    Set Variable    ${response['data']}
    Dictionary Should Contain Key    ${sessao_criada}    _id
    Dictionary Should Contain Key    ${sessao_criada}    seats
    Should Be Equal As Strings       ${sessao_criada['movie']}      ${dados_enviados['movie']}
    Should Be Equal As Strings       ${sessao_criada['theater']}    ${dados_enviados['theater']}
  
Conferência de lista de reservas
    [Arguments]    ${response}    ${id_sessao_esperada}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response}    count
    ${lista_reservas}=    Set Variable    ${response['data']}
    ${quantidade}=        Get Length    ${lista_reservas}
    Should Be True        ${quantidade} > 0
    ${primeira_reserva}=    Set Variable    ${lista_reservas}[0]
    Should Be Equal As Strings       ${primeira_reserva['session']['_id']}    ${id_sessao_esperada}

Conferência de reserva criada
    [Arguments]    ${response}    ${id_usuario_esperado}    ${id_sessao_esperada}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${reserva_criada}=    Set Variable    ${response['data']}
    # Garante que a reserva tem os campos essenciais
    Dictionary Should Contain Key    ${reserva_criada}    _id
    Dictionary Should Contain Key    ${reserva_criada}    user
    Dictionary Should Contain Key    ${reserva_criada}    session
    Dictionary Should Contain Key    ${reserva_criada}    seats
    Dictionary Should Contain Key    ${reserva_criada}    status
    Dictionary Should Contain Key    ${reserva_criada}    paymentStatus

 # conferinoo se a reserva pertence ao usuário e à sessão corretos
    Should Be Equal As Strings       ${reserva_criada['user']}              ${id_usuario_esperado}
    Should Be Equal As Strings       ${reserva_criada['session']['_id']}   ${id_sessao_esperada} 
    Should Be Equal As Strings       ${reserva_criada['status']}            confirmed

Conferência de lista geral de reservas
    [Arguments]    ${response}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    Dictionary Should Contain Key    ${response}    count
    ${lista_reservas}=    Set Variable    ${response['data']}
    ${quantidade}=        Get Length    ${lista_reservas}
    Should Be True        ${quantidade} > 0
    ${primeira_reserva}=    Set Variable    ${lista_reservas}[0]
    Dictionary Should Contain Key    ${primeira_reserva}    _id
    Dictionary Should Contain Key    ${primeira_reserva}    user
    Dictionary Should Contain Key    ${primeira_reserva}    session
    Dictionary Should Contain Key    ${primeira_reserva}    seats

Conferência de atualização de reserva
    [Arguments]    ${response}    ${status_esperado}
    Should Be True                   ${response['success']}
    Dictionary Should Contain Key    ${response}    data
    ${reserva_atualizada}=    Set Variable    ${response['data']}
    Dictionary Should Contain Key    ${reserva_atualizada}    _id
    Dictionary Should Contain Key    ${reserva_atualizada}    status
    Should Be Equal As Strings       ${reserva_atualizada['status']}    ${status_esperado}