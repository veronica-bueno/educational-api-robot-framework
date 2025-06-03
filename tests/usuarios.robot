*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/usuarios.resource

*** Test Cases ***
Usuários
    Cadastrar um novo usuário
    # Cadastrar usuário sem nome
    Buscar usuário cadastrado por ID
    Excluir usuário cadastrado
    Listar todos os usuarios cadastrados