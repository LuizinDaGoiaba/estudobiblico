# Bíblia com Estudo IA

Este projeto é um aplicativo Flutter que permite a navegação pelos livros da Bíblia, seleção de versículos e geração de estudos avançados com inteligência artificial, utilizando a API do OpenAI. O app armazena os estudos no Firebase Firestore e gerencia usuários via Firebase Authentication.

## Tecnologias utilizadas

- Flutter (front-end)
- Firebase Authentication (login e cadastro)
- Firebase Firestore (armazenamento dos estudos)
- OpenAI API (geração de conteúdo com IA)
- API da Bíblia Digital (dados da Bíblia)
- Variáveis de ambiente para gerenciamento de chaves

## Funcionalidades principais

- Navegação completa por livros e capítulos da Bíblia
- Busca por livros e versículos
- Geração automática de estudos avançados para versículos via OpenAI
- Registro, login e autenticação de usuários via Firebase
- Armazenamento dos estudos salvos por usuário no Firestore
- Interface escura, clean e minimalista

## Configuração do projeto

1. Clone este repositório:

```bash
git clone https://github.com/LuizinDaGoiaba/estudobiblico.git
```
## Instale as dependências:
```bash
flutter pub get
```
## Configure as variáveis de ambiente
- Crie um arquivo .env na raiz do projeto com a chave da API do OpenAI, por exemplo:
```bash
OPENAI_API_KEY=sua-chave-aqui
```
Atenção: não envie esse arquivo para o repositório. Inclua .env no .gitignore.
## Configure o Firebase no projeto, incluindo o arquivo firebase_options.dart gerado pelo FlutterFire CLI.
## Estrutura do projeto

![organizacao](https://github.com/user-attachments/assets/ff562080-9f03-4934-8432-6b3704323f3a)

## Prints das telas
## Tela inicial (Home Page)

![home page](https://github.com/user-attachments/assets/1f09fb68-3625-4232-8a31-403eda7f3d4d)

## Tela de login

![tela login](https://github.com/user-attachments/assets/3d34d9a2-91d1-4ab2-8f1a-ef217dc6c3d0)

## Tela de cadastro

![tela criar conta](https://github.com/user-attachments/assets/eea7d3f6-4923-4281-9feb-a07c8943d01b)

## Lista de capítulos e versículos

![capitulos](https://github.com/user-attachments/assets/42964037-1d08-4e55-a120-b4ef1e69faf9)

## Tela de estudo gerado pela IA

![estudo gerado openai](https://github.com/user-attachments/assets/e53e0534-eb72-42bc-86a0-460498d577fe)

## Tela de estudos salvos

![estudo salvo](https://github.com/user-attachments/assets/cbb850b2-7fe4-4ef1-8d4e-2fcb93a33129)

## Artigo mostrado pelo WebView

![webview](https://github.com/user-attachments/assets/ffa57144-f450-4f0b-9576-c6d9547813ea)

## Exemplo de geração de token para API da Bíblia

![git print copia](https://github.com/user-attachments/assets/6557b23e-31bb-4dd8-a56c-9c5d512aeb33)
