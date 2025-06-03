*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/produtos.resource

*** Test Cases ***
Categorias
    Cadastrar um novo produto
    Buscar produto cadastrado por ID
    Atualizar produto cadastrado
    Excluir produto cadastrado
    Listar todas os produtos cadastrados
    Cadastrar produto sem preço e quantidade
    Listar produtos por ID de uma categoria
    Buscar produto não cadastrado
    
