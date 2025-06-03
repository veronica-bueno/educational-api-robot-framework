*** Settings ***
Documentation    Configurações Globais 
Library          RequestsLibrary
Library          JSONLibrary
Library    Collections
Library    String

*** Variables ***
${URL_API}       https://educational-api-production.up.railway.app/api
${PATH_PAYLOAD_USUARIOS}   ${EXECDIR}/config/payload
${SSL_VERIFY}           False  # Nova variável para controle SSL
${PATH_PAYLOAD_CATEGORIAS}    ${EXECDIR}/config/payload

*** Keywords ***
Criar Sessão da API
    Create Session    API    ${URL_API}    verify=${SSL_VERIFY}    # Verify=false para ignorar a validação SSL
    
