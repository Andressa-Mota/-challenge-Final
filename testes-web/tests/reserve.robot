*** Settings ***
Documentation    cenarios de login
Library          Collections
Library          String
Library          Browser
Library    Dialogs
Resource         resources/base.resource
Resource    resources/reserve-page.resource


Test Setup       start session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-FE-013: Selecionar e deselecionar um assento
    [Tags]    RESERVA    ASSENTOS
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

CT-FE-014: Não deve selecionar um assento já ocupado
    [Tags]   Assentos    NEGATIVO

    #  Cria o primeiro usuário 
    ${email_user1}=    Generate Random String    8    [LOWER]
    ${user1}=          Create Dictionary    name=User Bloqueador    email=${email_user1}@test.com    password=senha123
    remover usuario do banco de dados    ${user1}[email] # Limpeza prévia
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user1}
    Conferir mensagem na tela    Conta criada com sucesso!
    ir para pagina de login
    submeter formulario de login    ${user1}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    ${titulo_filme}=         Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    ${titulo_do_assento_ocupado}=    Encontrar e clicar no primeiro assento disponível
    Click                     css=button >> text=Continuar para Pagamento
    Click                     css=button >> text=Finalizar Compra
    Conferir mensagem na tela   Reserva Confirmada!
    fazer logout
    #  Cria o segundo usuário 
    ${email_user2}=    Generate Random String    8    [LOWER]
    ${user2}=          Create Dictionary    name=User02    email=${email_user2}@test.com    password=senha123
    remover usuario do banco de dados    ${user2}[email]
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user2}
    Conferir mensagem na tela    Conta criada com sucesso!
    ir para pagina de login
    submeter formulario de login    ${user2}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    Ver detalhes do filme pelo título    ${titulo_filme} 
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    ${seletor_assento_ocupado}=    Set Variable    css=button[title^="${titulo_do_assento_ocupado}"]
    ${estados_do_assento}=         Get Element States    ${seletor_assento_ocupado}

   #tenta clicar no assento ocupado e espera um erro
    Verificar se o clique em elemento desabilitado falha    ${seletor_assento_ocupado}

CT-FE-015: Realizar uma reserva completa com sucesso
    [Tags]    RESERVA     SUCESSO

    ${email_rand}=    Generate Random String    8    [LOWER]
    ${user}=          Create Dictionary    name=Usuariocompleto    email=${email_rand}@test.com    password=senha123
    remover usuario do banco de dados    ${user}[email] 
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela    Conta criada com sucesso!
    ir para pagina de login
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!

    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    ${subtotal_inicial}=    Capturar subtotal
    ${assento1}=            Encontrar e clicar no primeiro assento disponível
    ${assento2}=            Encontrar e clicar no primeiro assento disponível
    ${subtotal_com_2_assentos}=    Capturar subtotal
    Should Be True           ${subtotal_com_2_assentos} > ${subtotal_inicial}
    Click      css=button.checkout-button
    Selecionar método de pagamento    Cartão de Crédito 
    Click    css=button >> text=Finalizar Compra
    Conferir mensagem na tela    Reserva Confirmada!

CT-FE-016: Visualizar reserva na página "Minhas Reservas" após a compra
    [Tags]    RESERVA     SUCESSO

    ${email_rand}=    Generate Random String    8    [LOWER]
    ${user}=          Create Dictionary    name=Usuario Final    email=${email_rand}@test.com    password=senha123
    remover usuario do banco de dados    ${user}[email] 
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela    Conta criada com sucesso!
    ir para pagina de login
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!

    ir para pagina inicial
    ${titulo_clicado}=       Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    ${assento_clicado}=      Encontrar e clicar no primeiro assento disponível
    Click                     css=button >> text=Continuar para Pagamento
    Selecionar método de pagamento    Cartão de Crédito
    Click    css=button >> text=Finalizar Compra
    Conferir mensagem na tela    Reserva Confirmada!
     ${codigo_reserva}=    Capturar código da reserva
    Conferir se a reserva está na lista    ${codigo_reserva}


CT-FE-017: Administrador deve visualizar e usar o botão "Liberar Assentos"
    [Tags]    ASSENTOS     ADM

    ${credenciais_adm}=    Cadastrar adm
    ir para pagina de login
    submeter formulario de login    ${credenciais_adm}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    Wait For Elements State    css=button.reset-seats-btn    visible    timeout=5s
    ${subtotal_inicial}=    Capturar subtotal
    ${titulo_do_assento}=    Encontrar e clicar no primeiro assento disponível
    Sleep    1s  # Pausa para o subtotal atualizar
    ${subtotal_selecionado}=    Capturar subtotal
    Should Be True    ${subtotal_selecionado} > ${subtotal_inicial}
    Click    css=button.reset-seats-btn
    Sleep    1s  # Pausa para a interface reagir
    ${subtotal_final}=       Capturar subtotal
    Should Be Equal As Numbers    ${subtotal_final}    ${subtotal_inicial}
CT-FE-018: Usuário comum não deve visualizar o botão "Resetar Assentos"
    [Tags]    ASSENTOS  NEGATIVO

    ${email_rand}=    Generate Random String    8    [LOWER]
    ${user}=          Create Dictionary    name=RegularUser    email=${email_rand}@test.com    password=senha123
    remover usuario do banco de dados    ${user}[email]
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela    Conta criada com sucesso!
    ir para pagina de login
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    ${titulo_clicado}=    Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
   # Verificamos que o botão 'Resetar Assentos' está no estado 'hidden' (não visível).
    Wait For Elements State   css=button >> text=Liberar Assentos    hidden    timeout=1s
    