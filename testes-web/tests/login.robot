*** Settings ***
Documentation    cenarios de login
Library    Collections

Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***
CT-FE-005: Processo de login
    [Tags]  LOGIN     SUCESSO
   ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    ir para pagina de login
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!

CT-FE-006: Processo de logout
    [Tags]  LOGOUT     SUCESSO
     ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    ir para pagina de login
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!
    fazer logout
    Conferir pagina de login

CT-FE-007: Acessar rotas protegidas apos logout
     [Tags]  LOGOUT     SUCESSO
     ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    ir para pagina de login
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!
    fazer logout
    Conferir pagina de login
    ir para pagina de reservas
    Conferir pagina de login

CT-FE-008: Vizualisar e editar perfil
    [Tags]  PERFIL    EDITAR
    ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    ir para pagina de login
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}
    submeter formulario de login    ${user}
    Conferir mensagem na tela    Login realizado com sucesso!
    ir para perfil
    Atualizar nome completo e salvar    Tester Novo
    Conferir mensagem na tela    Perfil atualizado com sucesso
    clicar ok