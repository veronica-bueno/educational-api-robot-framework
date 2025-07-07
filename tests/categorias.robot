*** Settings ***
Documentation    Este módulo de testes abrange a funcionalidade de gerenciamento de Categorias da API.
...              Ele verifica as operações de criação, listagem, busca por ID, atualização e exclusão de categorias,
...              garantindo que a API se comporte conforme o esperado para cada cenário, incluindo casos de sucesso e falha.
...              O objetivo é validar a integridade e a disponibilidade dos endpoints de Categorias.

Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/categorias.resource
Suite Setup    Criar Sessão da API

*** Test Cases ***
Categorias
    [Documentation]    Esta suíte executa uma sequência completa de testes para a funcionalidade de Categorias.
    ...                - Criação de uma nova categoria (cenário de sucesso e falha por falta de nome).
    ...                - Busca de categorias (por ID existente e ID inexistente, e listagem de todas).
    ...                - Atualização de uma categoria existente.
    ...                - Exclusão de uma categoria.
    ...                O objetivo é garantir a correta interação com os endpoints de Categorias da API.
    [Tags]            categorias

    Cadastrar uma nova categoria
    Buscar categoria cadastrada por ID
    Atualizar categoria cadastrada
    Excluir categoria cadastrada
    Listar todas as categorias cadastradas
    Tentativa de cadastrar uma categoria sem nome
    Tentativa de buscar uma categoria não cadastrada
    
