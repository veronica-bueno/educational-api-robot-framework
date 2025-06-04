*** Settings ***
Documentation    Este módulo de testes abrange a funcionalidade de gerenciamento de Produtos da API.
...              Ele verifica as operações de criação, listagem, busca por ID, atualização e exclusão de produtos,
...              garantindo que a API se comporte conforme o esperado para cada cenário, incluindo casos de sucesso e falha.
...              O objetivo é validar a integridade e a disponibilidade dos endpoints de Produtos.

Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/produtos.resource
Suite Setup    Criar Sessão da API

*** Test Cases ***
Produtos
    [Documentation]    Esta suíte executa uma sequência completa de testes para a funcionalidade de Produtos.
    ...                Ele abrange o ciclo de vida de um produto, incluindo:
    ...                - Criação de um novo produto (cenário de sucesso e falha por campos obrigatórios ausentes).
    ...                - Busca de produtos (por ID existente e ID inexistente, listagem de todos, e listagem por categoria).
    ...                - Atualização de um produto existente.
    ...                - Exclusão de um produto.
    ...                O objetivo é garantir a correta interação com os endpoints de Produtos da API.
    
    [Tags]             produtos

    Cadastrar um novo produto
    Buscar produto cadastrado por ID
    Atualizar produto cadastrado
    Excluir produto cadastrado
    Listar todas os produtos cadastrados
    Cadastrar produto sem preço e quantidade
    Listar produtos por ID de uma categoria
    Buscar produto não cadastrado
    
