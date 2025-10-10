*** Settings ***
Documentation    Elementos e ações de registro de usuarios

Library    Browser
Resource   libs/env.resource

*** Keywords ***

ir para pagina inicial

#iniciandoa sessão
    
    Go To    ${BASE_URL}/movies 

#checkpoint
   ${titulo_filmes_em_cartaz}=    Set Variable    css=.movies-container h1

    # 3. Checkpoint: Espera o elemento aparecer e verifica o texto
    Wait For Elements State        ${titulo_filmes_em_cartaz}    visible    timeout=5s
    Get Text    ${titulo_filmes_em_cartaz}        ==       Filmes em Cartaz

ir para pagina de cadastro

#iniciandoa sessão
    
    Go To    ${BASE_URL}/register

#checkpoint
   ${titulo_filmes_em_cartaz}=    Set Variable    css=.register-container h1

    # 3. Checkpoint: Espera o elemento aparecer e verifica o texto
    Wait For Elements State        ${titulo_filmes_em_cartaz}    visible    timeout=5s
    Get Text    ${titulo_filmes_em_cartaz}        ==       Cadastro

submeter o formulario de cadastro
    [Arguments]    ${user}
#prennchendo campos
     Fill Text    css=input[id=name]        ${user}[name]
     Fill Text    css=input[id=email]      ${user}[email]
     Fill Text    css=input[id=password]    ${user}[password]
     Fill Text    css=input[id=confirmPassword]    ${user}[password]

#cliando no botão
     Click    css=button[type=submit] >> text=Cadastrar
