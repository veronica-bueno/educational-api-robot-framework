*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/usuarios.resource

*** Test Cases ***
Usuários
    Cadastrar um novo usuário
    Buscar usuário cadastrado por ID
    Excluir usuário cadastrado
    Listar todos os usuarios cadastrados
    Cadastrar usuário sem nome
    Buscar usuário não cadastrado