*** Settings ***
Documentation    Este módulo de testes abrange a funcionalidade de gerenciamento de Usuários da API.
...              Ele verifica as operações de criação, listagem, busca por ID e exclusão de usuários,
...              garantindo que a API se comporte conforme o esperado para cada cenário, incluindo casos de sucesso e falha.
...              O objetivo é validar a integridade e a disponibilidade dos endpoints de Usuários.

Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/usuarios.resource
Suite Setup    Criar Sessão da API

*** Test Cases ***
Usuários
    [Documentation]    Esta suíte executa uma sequência completa de testes para a funcionalidade de Usuários.
    ...                Ele abrange o ciclo de vida de um usuário, incluindo:
    ...                - Criação de um novo usuário (cenário de sucesso e falha por campos obrigatórios ausentes).
    ...                - Busca de usuários (por ID existente e ID inexistente, e listagem de todos).
    ...                - Exclusão de um usuário.
    ...                O objetivo é garantir a correta interação com os endpoints de Usuários da API.
    
    [Tags]             usuarios 

    Cadastrar um novo usuário
    Buscar usuário cadastrado por ID
    Excluir usuário cadastrado
    Listar todos os usuarios cadastrados
    Cadastrar usuário sem nome
    Buscar usuário não cadastrado