Challenge final- Aplicação cinema, aplicação de Reserva de Ingressos
- Sobre o Projeto
A aplicação cinema é uma aplicação web desenvolvida para simular a experiência de um sistema de cinema. Usuários podem navegar pelos filmes em cartaz, visualizar detalhes, ver as sessões disponíveis e realizar a reserva de assentos de forma interativa.

A aplicação conta com um sistema de autenticação, diferenciação de perfis (usuário comum e administrador) e uma interface limpa e moderna para proporcionar uma experiência de usuário agradável.

-Funcionalidades Principais
Navegação de Filmes: Visualize os filmes em cartaz e os próximos lançamentos.

Detalhes do Filme: Acesse informações completas como sinopse, diretor, gênero e duração.

Sistema de Sessões: Verifique os horários e salas disponíveis para cada filme.

Seleção Interativa de Assentos: Escolha seus lugares em um mapa de assentos visual.

Autenticação de Usuários: Sistema de registro e login com perfis de usuário e administrador.

Reservas: Usuários podem criar e visualizar seu histórico de reservas.

Painel Administrativo (via API): Administradores podem gerenciar filmes, salas, sessões e usuários.

-Tecnologias Utilizadas
Área:
Front-end

React.js, Vite, Tailwind CSS

Back-end:
Node.js, Express.js, Mongoose

Banco de Dados:
MongoDB 

Autenticação
JSON Web Tokens (JWT)

- Executando o Projeto
Para executar a aplicação completa,é necessário rodar o Back-end (API) e o Front-end separadamente, em dois terminais diferentes.

Pré-requisitos
Antes de começar, é necessário ter instalados:

Node.js (v16 ou superior)

npm ou yarn

MongoDB (se for rodar o banco de dados localmente)

1. Configuração do Back-end (API)
O back-end é responsável por toda a lógica de negócio e comunicação com o banco de dados.

 Clone o repositório do back-end
git clone [https://github.com/juniorschmitz/cinema-challenge-back.git](https://github.com/juniorschmitz/cinema-challenge-back.git)

 Acesse a pasta do projeto
cd cinema-challenge-back

 Instale as dependências
npm install

Crie o arquivo de variáveis de ambiente
# foi criado um arquivo chamado .env na raiz do projeto e adicionado os conteúdo abaixo:

Conteúdo do arquivo .env:

# Porta em que o servidor irá rodar
PORT=3000

# Chave secreta para gerar os tokens de autenticação (JWT)

JWT_SECRET=chave-criptografica-secreta-super-segura

# String de conexão do MongoDB
MONGODB_URI=mongodb+srv://<seu_usuario>:<sua_senha>@<seu_cluster>.mongodb.net/<nome_do_banco>?retryWrites=true&w=majority
 5. Popule o banco de dados com dados iniciais
# (Execute os comandos na ordem)
npm run seed
node src/utils/seedMoreMovies.js
node src/utils/seedSessions.js

6. Inicie o servidor em modo de desenvolvimento
npm run dev

A API estará rodando em http://localhost:3000.

2. Configuração do Front-end


 1. Clone o repositório do front-end em outra pasta
git clone [https://github.com/juniorschmitz/cinema-challenge-front.git](https://github.com/juniorschmitz/cinema-challenge-front.git)

 2. Acesse a pasta do projeto
cd cinema-challenge-front

 3. Instale as dependências
npm install

 4. Inicie o servidor de desenvolvimento
npm start
