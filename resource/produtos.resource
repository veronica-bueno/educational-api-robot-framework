*** Settings ***
Documentation    Este arquivo contém as Keywords personalizadas para a funcionalidade de Produtos da API.
...              Ele define as operações de baixo nível para interagir com os endpoints de produtos.

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
    [Documentation]    Cria um novo produto enviando um payload JSON válido para o endpoint /products.
    ...                Gera nome, descrição, preço e quantidade aleatórios e associa a um ID de categoria existente.

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
    [Documentation]    Busca um produto específico utilizando o ID previamente cadastrado (variável ID Produto).
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém os detalhes do produto na chave 'data'.
    
    Log    ${ID_PRODUTO} 
    ${RESPONSE}=    GET    ${URL_API}/products/${ID_PRODUTO}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data
    Log    Produto por ID: ${DATA}

Atualizar produto cadastrado
    [Documentation]    Atualiza a descrição e quantidade de um produto existente usando o ID previamente cadastrado (ID Produto).
    ...                Remove campos como 'name', 'price' e 'category' do payload para testar a atualização parcial.
    ...                Verifica se o status da resposta é 200 OK e se a resposta reflete as informações atualizadas.
    
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
    [Documentation]    Exclui um produto existente utilizando o ID previamente cadastrado (ID Produto).
    ...                Verifica se o status da resposta é 200 OK e se a resposta de sucesso contém a mensagem e o status 'success' esperados.
    
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
    [Documentation]    Lista todos os produtos disponíveis na API.
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém uma lista de produtos na chave 'data'.
    
    ${RESPONSE}=    GET    ${URL_API}/products    expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Produtos cadastrados: ${DATA}

Cadastrar produto sem preço e quantidade
    [Documentation]    Tenta cadastrar um novo produto sem fornecer os campos 'price' e 'quantity' no payload.
    ...                Verifica se o status da resposta é 400 Bad Request e se a mensagem de erro esperada é retornada.

    ${ID_CATEGORIA}=    Obter ID de uma categoria existente
    Log    ID da Categoria utilizada: ${ID_CATEGORIA}

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
    [Documentation]    Lista produtos pertencentes a uma categoria específica usando o ID da categoria.
    ...                Verifica se o status da resposta é 200 OK e se a resposta contém uma lista de produtos para a categoria.
    
    ${ID_CATEGORIA}=    Obter ID de uma categoria existente
    Log    ID da Categoria para listagem: ${ID_CATEGORIA}

    ${RESPONSE}=    GET    ${URL_API}/products/category/${ID_CATEGORIA}  expected_status=200

    ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
    Log    ${RESPONSE_BODY}

    Dictionary Should Contain Key    ${RESPONSE_BODY}    data
    ${DATA}=    Get From Dictionary    ${RESPONSE_BODY}    data

    Log    Produtos da categoria de ID ${ID_CATEGORIA}: ${DATA}

Buscar produto não cadastrado
    [Documentation]    Tenta buscar um produto utilizando um ID que não existe na base de dados.
    ...                Gera um ID aleatório para garantir que não exista.
    ...                Verifica se o status da resposta é 404 Not Found e se a mensagem de erro esperada é retornada.

    ${ID_PRODUTO_ALEATORIO}    Generate Random String    length=10    chars=[NUMBERS]

    Log    ID de Produto aleatório para busca: ${ID_PRODUTO_ALEATORIO} 
    ${RESPONSE}=    GET    ${URL_API}/products/${ID_PRODUTO_ALEATORIO}  expected_status=404

    IF    ${RESPONSE.status_code} == 404
        ${RESPONSE_BODY}=    Set Variable    ${RESPONSE.json()}
        Log    ${RESPONSE_BODY}
        Dictionary Should Contain Key    ${RESPONSE_BODY}    message
        ${MESSAGE}=    Get From Dictionary    ${RESPONSE_BODY}    message
        Should Be Equal    ${MESSAGE}    Produto não encontrado.
    END