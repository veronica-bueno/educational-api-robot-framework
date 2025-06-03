*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Resource   ../config/config.resource
Resource    categorias.resource

*** Variables ***
${PRODUCTS_ENDPOINT}    /products

*** Keywords ***
Cadastrar um novo produto
    Criar Sessão da API
    ${ID_CATEGORIA}=    Obter ID de uma categoria existente
    Log    ${ID_CATEGORIA}

    ${JSON_PRODUTOS}=    Load Json From File    ${PATH_PAYLOAD}/produtos.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=10    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}
    ${PRECO_ALEATORIO}    Evaluate    random.randint(1, 9999)    modules=random
    ${QUANTIDADE_ALEATORIA}    Evaluate    random.randint(0, 999)    modules=random
    
    Set To Dictionary    ${JSON_PRODUTOS}    name=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_PRODUTOS}    description=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_PRODUTOS}    price=${PRECO_ALEATORIO}
    Set To Dictionary    ${JSON_PRODUTOS}    quantity=${QUANTIDADE_ALEATORIA}
    Set To Dictionary    ${JSON_PRODUTOS}    category=${ID_CATEGORIA}

    Log    Json enviado: ${JSON_PRODUTOS}

    ${RESPONSE}=    POST On Session    API    ${PRODUCTS_ENDPOINT}    json=${JSON_PRODUTOS}
    Log    Status code: ${RESPONSE.status_code}
    Log    Response content: ${RESPONSE.content}

    Status Should Be    201    ${RESPONSE}
    
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Dictionary Should Contain Key    ${DATA}    _id
    
    IF    ${RESPONSE.status_code} == 201
        ${ID_PRODUTO_RESPONSE}=    Get From Dictionary    ${DATA}    _id
        Set Test Variable    ${ID_PRODUTO}    ${ID_PRODUTO_RESPONSE}  
    END

Buscar produto cadastrado por ID
    Criar Sessão da API
    Log    ${ID_PRODUTO} 
    ${RESPONSE}=    GET    ${URL_API}/products/${ID_PRODUTO}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Produto por ID: ${DATA}

Atualizar produto cadastrado
    Criar Sessão da API
    ${JSON_PRODUTOS}=    Load Json From File    ${PATH_PAYLOAD}/produtos.json 
    Remove From Dictionary    ${JSON_PRODUTOS}    name
    Remove From Dictionary    ${JSON_PRODUTOS}    price
    Remove From Dictionary    ${JSON_PRODUTOS}    category

    ${QUANTIDADE_ALEATORIA}    Evaluate    random.randint(0, 999)    modules=random

    Set To Dictionary    ${JSON_PRODUTOS}    description=teste
    Set To Dictionary    ${JSON_PRODUTOS}    quantity=${QUANTIDADE_ALEATORIA}
    ${RESPONSE}=    PUT    ${URL_API}/products/${ID_PRODUTO}    json=${JSON_PRODUTOS}    expected_status=200
    
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Produto atualizado: ${DATA}

Excluir produto cadastrado
    Criar Sessão da API
    ${RESPONSE}=    DELETE    ${URL_API}/products/${ID_PRODUTO}    expected_status=200
    Log    ${RESPONSE}

    # Confirmar que produto foi deletado
    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    message
    Dictionary Should Contain Key    ${RESPONSE_BODY}    success

    ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
    ${SUCCESS}=    Get From Dictionary    ${RESPONSE_BODY}    success
    
    Should Be Equal    ${MESSAGE}    Produto removido com sucesso.
    Should Be True    ${SUCCESS}    

Listar todas os produtos cadastrados
    Criar Sessão da API
    ${RESPONSE}=    GET    ${URL_API}/products    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Produtos cadastrados: ${DATA}

Cadastrar produto sem preço e quantidade
    Criar Sessão da API
    ${ID_CATEGORIA}=    Obter ID de uma categoria existente
    Log    ${ID_CATEGORIA}

    ${JSON_PRODUTOS}=    Load Json From File    ${PATH_PAYLOAD}/produtos.json    # Carrega meu payload
  
    ${PALAVRA_ALEATORIA}    Generate Random String    length=10    chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case    ${PALAVRA_ALEATORIA}

    Remove From Dictionary    ${JSON_PRODUTOS}    price
    Remove From Dictionary    ${JSON_PRODUTOS}    quantity
    
    Set To Dictionary    ${JSON_PRODUTOS}    name=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_PRODUTOS}    description=${PALAVRA_ALEATORIA}
    Set To Dictionary    ${JSON_PRODUTOS}    category=${ID_CATEGORIA}
   
    Set To Dictionary    ${JSON_PRODUTOS}    description=${PALAVRA_ALEATORIA}
    Log    Json enviado: ${JSON_PRODUTOS}

    ${RESPONSE}=    POST On Session    API    ${PRODUCTS_ENDPOINT}    json=${JSON_PRODUTOS}    expected_status=400
    Log    Status code: ${RESPONSE.status_code}
    Log    Response content: ${RESPONSE.content}
  
    IF    ${RESPONSE.status_code} == 400
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        Log    ${RESPONSE_BODY}
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Por favor, preencha todos os campos obrigatórios: nome, descrição, preço, quantidade e categoria.
    END

Listar produtos por ID de uma categoria
    Criar Sessão da API
    ${ID_CATEGORIA}=    Obter ID de uma categoria existente
    Log    ${ID_CATEGORIA}

    ${RESPONSE}=    GET    ${URL_API}/products/category/${ID_CATEGORIA}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Produtos da categoria de ID ${ID_CATEGORIA}: ${DATA}

Buscar produto não cadastrado
    Criar Sessão da API

    ${ID_PRODUTO_ALEATORIO}    Generate Random String    length=10    chars=[NUMBERS]

    Log    ${ID_PRODUTO_ALEATORIO} 
    ${RESPONSE}=    GET    ${URL_API}/products/${ID_PRODUTO_ALEATORIO}  expected_status=404

    IF    ${RESPONSE.status_code} == 404
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        Log    ${RESPONSE_BODY}
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Produto não encontrado.
    END