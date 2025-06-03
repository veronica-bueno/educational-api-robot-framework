*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource   ../config/config.resource
Resource    ../resource/categorias.resource

*** Test Cases ***
Categorias
    Cadastrar uma nova categoria
    Buscar categoria cadastrada por ID
    Atualizar categoria cadastrada
    Excluir categoria cadastrada
    Listar todas as categorias cadastradas
    
