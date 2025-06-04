*** Settings ***
Documentation    Este arquivo contém as instruções detalhadas para automatizar os testes da 
...              funcionalidade de Categorias da API.

Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Resource   ../config/config.resource

*** Variables ***
${CATEGORIES_ENDPOINT}    /categories

*** Keywords ***
Cadastrar uma nova categoria
    [Documentation]    Cria uma nova categoria enviando um payload JSON válido para o endpoint /categories.
    ...                Gera um nome e descrição aleatórios para garantir unicidade.
    ...                Verifica se o status da resposta é 201 e se a resposta contém o ID da categoria criada.
    
    ${JSON_CATEGORIAS}=    Load Json From File    ${PATH_PAYLOAD}/categorias.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=10    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    Set To Dictionary    ${JSON_CATEGORIAS}    name=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_CATEGORIAS}    description=${PALAVRA_ALEATORIA}
    Log    Json enviado: ${JSON_CATEGORIAS}

    ${RESPONSE}=    POST On Session    API    ${CATEGORIES_ENDPOINT}    json=${JSON_CATEGORIAS}
    Log    Status code: ${RESPONSE.status_code}
    Log    Response content: ${RESPONSE.content}

    Status Should Be    201    ${RESPONSE}
    
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Dictionary Should Contain Key    ${DATA}    _id
    
    IF    ${RESPONSE.status_code} == 201
        ${ID_CATEGORIA_RESPONSE}=    Get From Dictionary    ${DATA}    _id
        Set Test Variable    ${ID_CATEGORIA}    ${ID_CATEGORIA_RESPONSE}  
    END

Buscar categoria cadastrada por ID
    [Documentation]    Busca uma categoria específica utilizando o ID previamente cadastrado (variável ID Categoria).
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém os detalhes da categoria na chave 'data'.
    
    Log    ${ID_CATEGORIA} 
    ${RESPONSE}=    GET    ${URL_API}/categories/${ID_CATEGORIA}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Categoria por ID: ${DATA}

Atualizar categoria cadastrada
    [Documentation]    Atualiza a descrição de uma categoria existente usando o ID previamente cadastrado (ID Categoria).
    ...                Remove o campo 'name' do payload para simular a atualização apenas da descrição.
    ...                Verifica se o status da resposta é 200 OK e se a resposta reflete a descrição atualizada.

    ${JSON_CATEGORIAS}=    Load Json From File    ${PATH_PAYLOAD}/categorias.json 
    Remove From Dictionary    ${JSON_CATEGORIAS}    name
    Set To Dictionary    ${JSON_CATEGORIAS}    description=teste
    ${RESPONSE}=    PUT    ${URL_API}/categories/${ID_CATEGORIA}    json=${JSON_CATEGORIAS}    expected_status=200
    
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Categoria atualizada: ${DATA}

Excluir categoria cadastrada
    [Documentation]    Exclui uma categoria existente utilizando o ID previamente cadastrado (ID Categoria).
    ...                Verifica se o status da resposta é 200 OK e se a resposta de sucesso contém a mensagem esperada.

    ${RESPONSE}=    DELETE    ${URL_API}/categories/${ID_CATEGORIA}    expected_status=200
    Log    ${RESPONSE}

    # Confirmar que categoria foi deletada
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    message
    Dictionary Should Contain Key    ${RESPONSE_BODY}    success

    ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
    ${SUCCESS}=    Get From Dictionary    ${RESPONSE_BODY}    success
    
    Should Be Equal    ${MESSAGE}    Categoria removida com sucesso.
    Should Be True    ${SUCCESS}    

Listar todas as categorias cadastradas
    [Documentation]    Lista todas as categorias disponíveis na API.
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém uma lista de categorias na chave 'data'.

    ${RESPONSE}=    GET    ${URL_API}/categories    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Categorias cadastradas: ${DATA}

Obter ID de uma categoria existente
    [Documentation]    Busca e retorna o ID de uma categoria existente na API.
    ...                Esta Keyword é útil como pré-condição para outros testes que exigem um ID de categoria válido.
    ...                Verifica se a lista de categorias não está vazia antes de extrair o ID.

    ${RESPONSE}=    GET    ${URL_API}/categories    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${CATEGORIES_LIST}=    Get From Dictionary    ${RESPONSE_BODY}    data

    # Verificar se a lista de categorias não está vazia
    Should Not Be Empty    ${CATEGORIES_LIST}    msg=Nenhuma categoria encontrada para obter ID.

    # Pegar a primeira categoria da lista
    ${PRIMEIRA_CATEGORIA}=    Get From List    ${CATEGORIES_LIST}    0

    # Extrair o ID da primeira categoria
    ${ID_PRIMEIRA_CATEGORIA}=    Get From Dictionary    ${PRIMEIRA_CATEGORIA}    _id
    Log    ID da categoria encontrada: ${ID_PRIMEIRA_CATEGORIA}

    RETURN    ${ID_PRIMEIRA_CATEGORIA}

Cadastrar categoria sem nome
    [Documentation]    Tenta cadastrar uma nova categoria sem fornecer o campo 'name' no payload.
    ...                Verifica se o status da resposta é 400 Bad Request e se a mensagem de erro esperada é retornada.

    ${JSON_CATEGORIAS}=    Load Json From File    ${PATH_PAYLOAD}/categorias.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=10    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
   
    # Não define o campo 'name' para simular a ausência.
    Set To Dictionary    ${JSON_CATEGORIAS}    description=${PALAVRA_ALEATORIA}
    Log    Json enviado: ${JSON_CATEGORIAS}

    ${RESPONSE}=    POST On Session    API    ${CATEGORIES_ENDPOINT}    json=${JSON_CATEGORIAS}    expected_status=400
    Log    Status code: ${RESPONSE.status_code}
    Log    Response content: ${RESPONSE.content}
  
    IF    ${RESPONSE.status_code} == 400
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        Log    ${RESPONSE_BODY}
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Por favor, preencha todos os campos obrigatórios: nome e descrição.
    END

Buscar categoria não cadastrada
    [Documentation]    Tenta buscar uma categoria utilizando um ID que não existe na base de dados.
    ...                Verifica se o status da resposta é 404 Not Found e se a mensagem de erro esperada é retornada.

    ${ID_CATEGORIA_ALEATORIA}    Generate Random String    length=10    chars=[NUMBERS]

    Log    ${ID_CATEGORIA_ALEATORIA} 
    ${RESPONSE}=    GET    ${URL_API}/categories/${ID_CATEGORIA_ALEATORIA}  expected_status=404

    IF    ${RESPONSE.status_code} == 404
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        Log    ${RESPONSE_BODY}
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Categoria não encontrada.
    END

