*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Resource          ../common.resource

*** Keywords ***

Listar filmes
    [Arguments]    ${status_esperado}
    ${resposta}=   GET On Session    cinema    /movies    expected_status=${status_esperado}
    RETURN         ${resposta}

Obter filme por ID
    [Arguments]    ${movie_id}    ${status_esperado}
    ${resposta}=   GET On Session    cinema    /movies/${movie_id}    expected_status=${status_esperado}
    RETURN         ${resposta}

Criar filme com token
    [Arguments]    ${token}    ${dados_do_filme}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   POST On Session    cinema    /movies    json=${dados_do_filme}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Atualizar filme com token
    [Arguments]    ${token}    ${id_do_filme}    ${novos_dados}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   PUT On Session    cinema    /movies/${id_do_filme}    json=${novos_dados}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Deletar filme com token
    [Arguments]    ${token}    ${id_do_filme}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   DELETE On Session    cinema    /movies/${id_do_filme}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}