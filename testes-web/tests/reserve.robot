*** Settings ***
Documentation    cenarios de login
Library    Collections


Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***

CT-FE-013: Selecionar e deselecionar um assento
    [Tags]    ASSENTOS  RESERVAS

    #  Cadastrar um novo usuário 
    ${random_email}=    Generate Random String    8    [LOWER]
    ${user}=             Create Dictionary
    ...                  name=Tester123
    ...                  email=${random_email}@test.com
    ...                  password=senha123

    # Garante que o usuário não existe de um teste anterior
    remover usuario do banco de dados    ${user}[email]

    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela     Conta criada com sucesso!

    # Fazer login
    ir para pagina de login
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!

    #  Navegar e interagir com a interface como um usuário logado 
    ${titulo_clicado}=       Selecionar o primeiro filme da lista e ver detalhes
    Selecionar a primeira sessão da lista
    Wait For Elements State    css=.seats-container    visible    timeout=5s

    # Ação e Validação de assentos
    ${seletor_subtotal}=      Set Variable    css=span.price
    ${subtotal_inicial_texto}=    Get Text    ${seletor_subtotal}
    ${subtotal_inicial_num}=  Extrair valor numerico do preco    ${subtotal_inicial_texto}

   ${assento_clicado}=       Encontrar e clicar no primeiro assento disponível

# Esperar até que a classe 'selected' apareça
    Wait For Condition    classes    ${assento_clicado}    contains    selected

    ${classe_assento}=    Get Attribute    ${assento_clicado}    class
    Should Contain        ${classe_assento}    selected


    ${subtotal_apos_clique_texto}=  Get Text    ${seletor_subtotal}
    ${subtotal_apos_clique_num}=    Extrair valor numerico do preco    ${subtotal_apos_clique_texto}
    Should Be True        ${subtotal_apos_clique_num} > ${subtotal_inicial_num}

# Deselecionar o mesmo assento 
    Click    ${assento_clicado}

# Verificar se o assento voltou ao estado inicial
    # Esperar o assento voltar ao estado 'available'
    Wait For Condition    classes    ${assento_clicado}    contains    available
    Wait For Condition    classes    ${assento_clicado}    not contains    selected

    ${classe_final}=    Get Attribute    ${assento_clicado}    class
    Should Contain      ${classe_final}    available
    Should Not Contain  ${classe_final}    selected
    ${subtotal_final_texto}=         Get Text    ${seletor_subtotal}
    ${subtotal_final_num}=           Extrair valor numerico do preco    ${subtotal_final_texto}
    Should Be Equal As Numbers       ${subtotal_final_num}    ${subtotal_inicial_num}
