*** Settings ***
Documentation    Este arquivo contém as instruções detalhadas para automatizar os testes da 
...              funcionalidade de Usuários da API.

Library          RequestsLibrary
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Resource   ../config/config.resource

*** Variables ***
${USERS_ENDPOINT}    /users

*** Keywords ***
Cadastrar um novo usuário
    [Documentation]    Cria um novo usuário enviando um payload JSON válido para o endpoint /users.
    ...                Gera nome e email aleatórios para garantir unicidade.
    ...                Verifica o status 201 Created e captura o ID do usuário criado na variável ID Usuários.

    ${JSON_USUARIOS}=    Load Json From File    ${PATH_PAYLOAD}/usuarios.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=6    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    Set To Dictionary    ${JSON_USUARIOS}    name=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_USUARIOS}    email=${PALAVRA_ALEATORIA}@emailteste.com


    ${RESPONSE}=    POST On Session    API    ${USERS_ENDPOINT}    json=${JSON_USUARIOS}


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
    [Documentation]    Busca um usuário específico utilizando o ID previamente cadastrado (variável ID Usuários).
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém os detalhes do usuário na chave 'data'.
    

    ${RESPONSE}=    GET    ${URL_API}/users/${ID_USUARIO}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data


Excluir usuário cadastrado
    [Documentation]    Exclui um usuário existente utilizando o ID previamente cadastrado (variável ID Usuários).
    ...                Verifica se o status da resposta é 200 OK e se a resposta de sucesso contém a mensagem e o status 'success' esperados.
   
    ${RESPONSE}=    DELETE    ${URL_API}/users/${ID_USUARIO}    expected_status=200


    # Confirmar que usuário foi deletado
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}


    Dictionary Should Contain Key    ${RESPONSE_BODY}    message
    Dictionary Should Contain Key    ${RESPONSE_BODY}    success

    ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
    ${SUCCESS}=    Get From Dictionary    ${RESPONSE_BODY}    success
    
    Should Be Equal    ${MESSAGE}    Usuário removido com sucesso.
    Should Be True    ${SUCCESS}    

Listar todos os usuarios cadastrados
    [Documentation]    Lista todos os usuários disponíveis na API.
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém uma lista de usuários na chave 'data'.
    
    ${RESPONSE}=    GET    ${URL_API}/users    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    
Tentativa de cadastrar usuário sem nome
    [Documentation]    Tenta cadastrar um novo usuário sem fornecer o campo 'name' no payload.
    ...                Verifica se o status da resposta é 400 Bad Request e se a mensagem de erro esperada é retornada.
    
    ${JSON_USUARIOS}=    Load Json From File    ${PATH_PAYLOAD}/usuarios.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=6    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    Set To Dictionary    ${JSON_USUARIOS}    email=${PALAVRA_ALEATORIA}@emailteste.com
    Remove From Dictionary  ${JSON_USUARIOS}        name    # Remove o campo 'name' para simular a ausência

    ${RESPONSE}=    POST On Session    API    ${USERS_ENDPOINT}    json=${JSON_USUARIOS}    expected_status=400

    IF    ${RESPONSE.status_code} == 400
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}

        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Por favor, preencha todos os campos obrigatórios: nome e email.
    END

Tentativa de buscar usuário não cadastrado
    [Documentation]    Tenta buscar um usuário utilizando um ID que não existe na base de dados.
    ...                Gera um ID aleatório para garantir que não exista.
    ...                Verifica se o status da resposta é 404 Not Found e se a mensagem de erro esperada é retornada.

    ${ID_USUARIO_ALEATORIO}    Generate Random String    length=10    chars=[NUMBERS]

    Log    ID de Usuário aleatório para busca: ${ID_USUARIO_ALEATORIO} 
    ${RESPONSE}=    GET    ${URL_API}/users/${ID_USUARIO_ALEATORIO}  expected_status=404

    IF    ${RESPONSE.status_code} == 404
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Usuário não encontrado.
    END