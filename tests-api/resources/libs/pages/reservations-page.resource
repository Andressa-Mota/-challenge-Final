*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Resource          ../common.resource

*** Keywords ***

Criar reserva com token
    [Arguments]    ${token}    ${dados_da_reserva}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   POST On Session    cinema    /reservations    json=${dados_da_reserva}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Listar minhas reservas
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   GET On Session    cinema    /reservations/me    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Encontrar primeiro assento disponível
    [Arguments]    ${lista_de_assentos}
    FOR    ${assento}    IN    @{lista_de_assentos}
        IF    '${assento['status']}' == 'available'
            RETURN    ${assento}
        END
    END
    Fail    Não foram encontrados assentos disponíveis na sessão.
    #keyword criada com auxilio de IA pois não possuia entendimento suficiente FOR e IF para desenvolver sozinha

Listar todas as reservas com token
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   GET On Session    cinema    /reservations    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Deletar reserva com token
    [Arguments]    ${token}    ${id_da_reserva}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   DELETE On Session    cinema    /reservations/${id_da_reserva}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}

Atualizar reserva com token
    [Arguments]    ${token}    ${id_da_reserva}    ${novos_dados}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resposta}=   PUT On Session    cinema    /reservations/${id_da_reserva}    json=${novos_dados}    headers=${headers}    expected_status=${status_esperado}
    RETURN         ${resposta}