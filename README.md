# educational-api-robot-framework

#### Projeto de Automação de Testes de API

Este projeto contém testes de automação para uma API pública, desenvolvidos utilizando Robot Framework.

A API possui documentação conforme URLs abaixo:
- [Educational API - Swagger](https://educational-api-75qy.onrender.com/api-docs/)
- [Educational API - JSON](https://educational-api-75qy.onrender.com/swagger.json)

#### Requisitos para Configuração e Execução
Para configurar e executar os testes de API neste projeto, siga os passos abaixo:

**1. Ambiente de Desenvolvimento**
- **Python:** É necessário ter o Python instalado (versão 3.6 ou superior é recomendada). Você pode baixá-lo do site oficial do Python: python.org

- **Editor de Código:** Um editor de código com suporte a Robot Framework (como VS Code com a extensão Robot Framework Language Server) é altamente recomendado para facilitar a escrita e manutenção dos testes.

- **Git:** Para controle de versão e colaboração no GitHub, o Git deve estar instalado.

**2. Instalação das Dependências**
- Após clonar o repositório, navegue até a pasta raiz do projeto no seu terminal e instale as bibliotecas Python necessárias utilizando o pip e o arquivo **requirements.txt** fornecido:

```bash
    pip install -r requirements.txt
```

**3. Estrutura de Pastas do Projeto**
- A estrutura de pastas do projeto está organizada da seguinte forma:

```
    educational-api-robot-framework/
    ├── artefatos/
    │   ├── 00_user_story.txt
    │   ├── 01_plano_de_teste.txt
    │   ├── 02_suíte_de_teste.txt
    │   └── 03_casos_de_teste.txt
    ├── config/
    │   ├── payload/
    │   │   ├── categorias.json
    │   │   ├── produtos.json
    │   │   └── usuarios.json
    │   └── config.resource
    ├── reports/
    │   ├── log.html
    │   ├── output.xml
    │   ├── report.html
    ├── resource/
    │   ├── categorias.resource
    │   ├── produtos.resource
    │   └── usuarios.resource
    ├── tests/
    │   ├── categorias.robot
    │   ├── produtos.robot
    │   └── usuarios.robot
    ├── .gitignore
    ├── README.md (Este arquivo)
    └── requirements.txt
```

**4. Configuração da API**
- **URL da API:** A variável ${URL_API} no arquivo config/config.resource já esta configurada para a URL base correta da API que será testada.

- **Payloads JSON:** Os arquivos JSON dentro da pasta config/payload já está configurada com os dados de exemplo corretos para as requisições de criação e atualização de recursos da API que será testada.

**5. Execução dos Testes:**
- Nesta etapa o projeto ja estara configurado e para executar os testes basta navegar até a pasta ```tests``` no terminal e use os comandos robot conforme abaixo:

```bash
    cd educational-api-robot-framework
    robot -d reports tests\produtos.robot
    robot -d reports tests\usuarios.robot
    robot -d reports tests\categorias.robot
    # Ou para executar todos os testes em uma pasta:
    robot -d reports tests/
```

Para verificar os logs ou o report dos testes basta abrir os respectivos arquivos na pasta ```reports``` (log.html e report.html).
