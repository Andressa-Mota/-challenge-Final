*** Settings ***
Library    libs/database.py
Library    Browser
Library    JSONLibrary
Resource   libs/env.resource
Resource   register-page.resource
Resource     login-page.resource
Resource    checkweb.resource
Resource    films-page.resource
Resource    sessions-page.resource

*** Keywords ***

start session
    New Browser    browser=chromium    headless=false
    New Page    ${BASE_URL}

# senhas curtas
#     [Arguments]    ${senha_curta}
#         ${user}    Create Dictionary    
#     ...    name=andressa
#     ...    email=test03@mail.com
#     ...    password=${senha_curta}
#     ir para pagina de cadastro
#     submeter o formulario de cadastro    ${user}  
#     mensagens de alerta    Informe uma senha com pelo menos 6 digitos

# receber fixtures
#      [Arguments]    ${arquivo}   ${cenario}
#            ${data}     Load Json From File    ${EXECDIR}/Tests_web/resources/fixtures/${arquivo}     encoding=utf-8
#            Log    ${data}
#            RETURN    ${data}[${cenario}]