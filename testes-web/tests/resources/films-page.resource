*** Settings ***
Documentation    Elementos e ações de login
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library            OperatingSystem
Library           String
Library    Browser
Resource   libs/env.resource

*** Keywords ***
importar json estatico
    [Arguments]    ${nome_arquivo}
    ${json}       Load JSON From File   ${CURDIR}/fixtures/${nome_arquivo}    encoding=UTF-8
    RETURN       ${json}

Cadastrar adm

    ${json}=          importar json estatico    user.json
    ${body_adm}=      Get From Dictionary       ${json}    usuario_adm
    ${password}=      Get From Dictionary       ${body_adm}    password
    ${email_rand}=    Generate Random String    6    [LOWER]
    ${email}=         Set Variable              ${email_rand}adm@mail.com
    Set To Dictionary    ${body_adm}    email    ${email}
    ${nome_rand}=     Generate Random String    4    [LOWER]
    Set To Dictionary    ${body_adm}    name     ${nome_rand}admtester
    remover usuario do banco de dados    ${email}
    inserir usuario no banco de dados    ${body_adm}
    ${credenciais}=    Create Dictionary    email=${email}    password=${password}
    RETURN            ${credenciais}

ir para pagina de adm
    Click   css=a >> text=Administração

Ver detalhes do filme pelo título
    [Arguments]    ${titulo_do_filme}

    # Este primeiro seletor encontra o "card" do filme que contém o título esperado.
    ${seletor_card_filme}=    Set Variable    css=.movie-card:has-text("${titulo_do_filme}")
    ${seletor_botao}=         Set Variable    ${seletor_card_filme} >> text=Ver Detalhes
    Click    ${seletor_botao}
    # Esta keyword foi criada cm auxilio de IA, pois não consegui resolver sozinha o problema de existir varios botões com o mesmo nome para ver os detalhes de um filme

Selecionar o primeiro filme da lista e ver detalhes
    [Documentation]    Encontra o primeiro filme na lista, obtém seu título,
    ...                clica em 'Ver Detalhes' e retorna o título encontrado.

    
    # separado por vírgula do índice.
    ${seletor_primeiro_titulo}=    Set Variable    css=:nth-match(h3.movie-title, 1)
    Wait For Elements State    ${seletor_primeiro_titulo}    visible    timeout=10s
    ${titulo_encontrado}=    Get Text    ${seletor_primeiro_titulo}

    Ver detalhes do filme pelo título    ${titulo_encontrado}

    RETURN    ${titulo_encontrado}
    # Esta keyword foi criada cm auxilio de IA, pois não consegui resolver sozinha o problema de existir varios botões com o mesmo nome para ver os detalhes de um filme