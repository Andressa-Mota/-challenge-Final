*** Settings ***
Documentation    cenarios de login
Library          Collections
Library          String
Library          Browser
Library    Dialogs
Resource         resources/base.resource


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
    [Tags]    SEATS   NEGATIVE   WEB

    # --- SETUP 1: Usuário 1 (Ocupa o assento) ---
    # 1.1: Cria o primeiro usuário (o bloqueador) via interface
    ${email_user1}=    Generate Random String    8    [LOWER]
    ${user1}=          Create Dictionary    name=User Bloqueador    email=${email_user1}@test.com    password=senha123
    remover usuario do banco de dados    ${user1}[email] # Limpeza prévia
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user1}
    Conferir mensagem na tela    Conta criada com sucesso!

    # 1.2: Faz o login e reserva o assento
    ir para pagina de login
    submeter formulario de login    ${user1}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    ${titulo_filme}=         Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s
    ${titulo_do_assento_ocupado}=    Encontrar e clicar no primeiro assento disponível
    # Finaliza a reserva para que o assento fique 'occupied' (ocupado)
    Click                     css=button >> text=Continuar para Pagamento
    Click                     css=button >> text=Finalizar Compra
    Conferir mensagem na tela   Reserva Confirmada!
    fazer logout

    # --- SETUP 2: Usuário 2 (O Testador) ---
    # 2.1: Cria o segundo usuário (o que vai testar) via interface
    ${email_user2}=    Generate Random String    8    [LOWER]
    ${user2}=          Create Dictionary    name=User Testador    email=${email_user2}@test.com    password=senha123
    remover usuario do banco de dados    ${user2}[email]
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user2}
    Conferir mensagem na tela    Conta criada com sucesso!

    # 2.2: Faz o login e navega para a mesma sessão que o Usuário 1
    ir para pagina de login
    submeter formulario de login    ${user2}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para pagina inicial
    Ver detalhes do filme pelo título    ${titulo_filme} 
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s

    # --- VALIDAÇÃO FINAL: Verificar se o assento ocupado está desabilitado ---
    # Construímos o seletor para o assento que o Usuário 1 ocupou
    ${seletor_assento_ocupado}=    Set Variable    css=button[title^="${titulo_do_assento_ocupado}"]

    # Verificamos os estados do botão, provando que a aplicação o bloqueou
    ${estados_do_assento}=         Get Element States    ${seletor_assento_ocupado}

   #tenta clicar no assento ocupado e espera um erro
    Verificar se o clique em elemento desabilitado falha    ${seletor_assento_ocupado}