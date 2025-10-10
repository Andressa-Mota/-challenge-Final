*** Settings ***
Documentation    cenarios de atenticação
Library    Collections

Resource    resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***

CT-FE-001: Ir para página inicial
    [Tags]    CADASTRO
    ir para pagina inicial
   
CT-FE-002: registrar novo usuario
    [Tags]    CADASTRO
    #definindo dados do usuário
    ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    #garantindo que ele não seja nunca duplicado removendo esse endereço de email do banco de dados antes de cadastrar
    remover usuario do banco de dados     ${user}[email]
    #entrando na pagina de cadastro
    ir para pagina de cadastro
    #adicionando os dados ao formulário
    submeter o formulario de cadastro    ${user}
     #conferindo a mensagem de sucesso que aparece na tela
    Conferir mensagem na tela       Conta criada com sucesso!
    #usando esse fluxo temos um caso de teste completo e independente

CT-FE-003: registrar com email duplicado
    [Tags]    CADASTRO     DUPLICIDADE
#definindovariaveis do teste
    ${user}    Create Dictionary    
    ...    name=tester    
    ...    email=test02@mail.com  
    ...    password=senha124

#deletando um apossivel massa de testes incorreta
    remover usuario do banco de dados     ${user}[email]
#adicionando o usuario com os dados definidos no banco de dados
    inserir usuario no banco de dados    ${user}  

    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    Conferir mensagem na tela   User already exists

CT-FE-004: registrar com campo vazio
    [Tags]    CADASTRO     VAZIO  
      ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=
    remover usuario do banco de dados     ${user}[email]
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
      Conferir mensagem de validação de campo    css=input[id=password]    Preencha este campo.
