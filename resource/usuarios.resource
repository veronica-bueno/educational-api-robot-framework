*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Resource   ../config/config.resource

*** Variables ***
${USERS_ENDPOINT}    /users


*** Keywords ***
Cadastrar um novo usuário
    # Cria a sessão
    Criar Sessão da API
    ${JSON_USUARIOS}=    Load Json From File    ${PATH_PAYLOAD}/usuarios.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=6    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    Set To Dictionary    ${JSON_USUARIOS}    name=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_USUARIOS}    email=${PALAVRA_ALEATORIA}@emailteste.com
    Log    Json enviado: ${JSON_USUARIOS}

    ${RESPONSE}=    POST On Session    API    ${USERS_ENDPOINT}    json=${JSON_USUARIOS}
    Log    Status code: ${RESPONSE.status_code}
    Log    Response content: ${RESPONSE.content}

    Status Should Be    201    ${RESPONSE}
    
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Dictionary Should Contain Key    ${DATA}    _id

    IF    ${RESPONSE.status_code} == 201
        ${ID_USUARIO_RESPONSE}=    Get From Dictionary    ${DATA}    _id
        Set Test Variable    ${ID_USUARIO}    ${ID_USUARIO_RESPONSE}  
    END


Buscar usuário cadastrado por ID
    Criar Sessão da API
    Log    ${ID_USUARIO} 
    ${RESPONSE}=    GET    ${URL_API}/users/${ID_USUARIO}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Usuário por ID: ${DATA}

Excluir usuário cadastrado
    Criar Sessão da API
    ${RESPONSE}=    DELETE    ${URL_API}/users/${ID_USUARIO}    expected_status=200
    Log    ${RESPONSE}

    # Confirmar que usuário foi deletado
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    message
    Dictionary Should Contain Key    ${RESPONSE_BODY}    success

    ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
    ${SUCCESS}=    Get From Dictionary    ${RESPONSE_BODY}    success
    
    Should Be Equal    ${MESSAGE}    Usuário removido com sucesso.
    Should Be True    ${SUCCESS}    

Listar todos os usuarios cadastrados
    Criar Sessão da API
    ${RESPONSE}=    GET    ${URL_API}/users    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Usuários cadastrados: ${DATA}
    


# Cadastrar usuário sem nome
#     # Criamos um payload sem o campo 'name'
#     Create Session    API    ${URL_API}    verify=true 
#     ${random_email}=    Generate Random String    length=10    chars=[LETTERS][DIGITS]
#     ${payload_sem_nome}=    Create Dictionary    email=${random_email}@emailteste.com

#     Log    Payload enviado: ${payload_sem_nome}

#     ${RESPONSE}=    POST On Session    API   ${USERS_ENDPOINT}    json=${payload_sem_nome}
#     Log    Status code: ${RESPONSE}
    # Log    Response content: ${RESPONSE.reason}

    # Validar o status de retorno
    # Status Should Be    400    ${RESPONSE.status}

    # Validar a mensagem de erro no corpo da resposta
    # ${response_body}=    Set Variable    ${RESPONSE.json()}
    # Dictionary Should Contain Key    ${response_body}    message
    # ${error_message}=    Get From Dictionary    ${response_body}    message
    # Log    erros message:${error_message}
    # Should Contain    ${error_message}    nome    msg=Por favor, preencha todos os campos obrigatórios: nome e email.

    # Create Session    API    ${URL_API}    verify=${SSL_VERIFY}   # Verify=false para ignorar a validação SSL
    # ${JSON_USUARIOS}=    Load Json From File    ${PATH_PAYLOAD}/usuarios.json    # Carrega meu payload
  
    # ${PALAVRA_ALEATORIA}    Generate Random String    length=6    chars=[LETTERS]
    # ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    # Set To Dictionary    ${JSON_USUARIOS}    name=
    # Set To Dictionary    ${JSON_USUARIOS}    email=${PALAVRA_ALEATORIA}@emailteste.com
    # Log    Json enviado: ${JSON_USUARIOS}

    # ${RESPONSE}=    POST On Session    API    ${USERS_ENDPOINT}    json=${JSON_USUARIOS}
    # Log    Status code: ${RESPONSE.status_code}
    # Log    Response content: ${RESPONSE.content}

    # Status Should Be    400    ${RESPONSE}

    # ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    # Log    response body: ${RESPONSE_BODY}
    # Dictionary Should Contain Key    ${RESPONSE_BODY}    message
    # ${message}=    Get From Dictionary    ${RESPONSE_BODY}    message
    # Log    data: ${message}
    # # Dictionary Should Contain Key    ${DATA}    _id
    # Should Be Equal    ${message}    Por favor, preencha todos os campos obrigatórios: nome e email.
    # # ...  ${message}    message    Por favor, preencha todos os campos obrigatórios: nome e email.


    # Create Session    api    ${URL_API}    verify=False
    # ${PAYLOAD}=    Create Dictionary
    # ...    email=semnome@email.com    # omite o campo "name"
    # ${response}=    POST On Session    api    ${USERS_ENDPOINT}    json=${PAYLOAD}

    # Log    Status code: ${response.status_code}
    # Log    Response content: ${response.content}

    # Status Should Be    400    ${response}
    # ${response_body}=    Set Variable    ${response.json()}
    # Dictionary Should Contain Key    ${response_body}    message
    # Should Contain    ${response_body['message']}    nome