# Desafio técnico e-commerce

## Nossas expectativas

A equipe de engenharia da RD Station tem alguns princípios nos quais baseamos nosso trabalho diário. Um deles é: projete seu código para ser mais fácil de entender, não mais fácil de escrever.

Portanto, para nós, é mais importante um código de fácil leitura do que um que utilize recursos complexos e/ou desnecessários.

O que gostaríamos de ver:

- O código deve ser fácil de ler. Clean Code pode te ajudar.
- Notas gerais e informações sobre a versão da linguagem e outras informações importantes para executar seu código.
- Código que se preocupa com a performance (complexidade de algoritmo).
- O seu código deve cobrir todos os casos de uso presentes no README, mesmo que não haja um teste implementado para tal.
- A adição de novos testes é sempre bem-vinda.
- Você deve enviar para nós o link do repositório público com a aplicação desenvolvida (GitHub, BitBucket, etc.).

## O Desafio - Carrinho de compras
O desafio consiste em uma API para gerenciamento do um carrinho de compras de e-commerce.

Você deve desenvolver utilizando a linguagem Ruby e framework Rails, uma API Rest que terá 3 endpoins que deverão implementar as seguintes funcionalidades:

### 1. Registrar um produto no carrinho
Criar um endpoint para inserção de produtos no carrinho.

Se não existir um carrinho para a sessão, criar o carrinho e salvar o ID do carrinho na sessão.

Adicionar o produto no carrinho e devolver o payload com a lista de produtos do carrinho atual.


ROTA: `/cart`
Payload:
```js
{
  "product_id": 345, // id do produto sendo adicionado
  "quantity": 2, // quantidade de produto a ser adicionado
}
```

Response
```js
{
  "id": 789, // id do carrinho
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96 // valor total no carrinho
}
```

### 2. Listar itens do carrinho atual
Criar um endpoint para listar os produtos no carrinho atual.

ROTA: `/cart`

Response:
```js
{
  "id": 789, // id do carrinho
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96 // valor total no carrinho
}
```

### 3. Alterar a quantidade de produtos no carrinho 
Um carrinho pode ter _N_ produtos, se o produto já existir no carrinho, apenas a quantidade dele deve ser alterada

ROTA: `/cart/add_item`

Payload
```json
{
  "product_id": 1230,
  "quantity": 1
}
```
Response:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2, // considerando que esse produto já estava no carrinho
      "unit_price": 7.00, 
      "total_price": 14.00, 
    },
    {
      "id": 01020,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90, 
      "total_price": 9.90, 
    },
  ],
  "total_price": 23.9
}
```

### 3. Remover um produto do carrinho 

Criar um endpoint para excluir um produto do do carrinho. 

ROTA: `/cart/:product_id`


#### Detalhes adicionais:

- Verifique se o produto existe no carrinho antes de tentar removê-lo.
- Se o produto não estiver no carrinho, retorne uma mensagem de erro apropriada.
- Após remover o produto, retorne o payload com a lista atualizada de produtos no carrinho.
- Certifique-se de que o endpoint lida corretamente com casos em que o carrinho está vazio após a remoção do produto.

### 5. Excluir carrinhos abandonados
Um carrinho é considerado abandonado quando estiver sem interação (adição ou remoção de produtos) há mais de 3 horas.

- Quando este cenário ocorrer, o carrinho deve ser marcado como abandonado.
- Se o carrinho estiver abandonado há mais de 7 dias, remover o carrinho.
- Utilize um Job para gerenciar (marcar como abandonado e remover) carrinhos sem interação.
- Configure a aplicação para executar este Job nos períodos especificados acima.

### Detalhes adicionais:
- O Job deve ser executado regularmente para verificar e marcar carrinhos como abandonados após 3 horas de inatividade.
- O Job também deve verificar periodicamente e excluir carrinhos que foram marcados como abandonados por mais de 7 dias.

### Como resolver

#### Implementação
Você deve usar como base o código disponível nesse repositório e expandi-lo para que atenda as funcionalidade descritas acima.

Há trechos parcialmente implementados e também sugestões de locais para algumas das funcionalidades sinalizados com um `# TODO`. Você pode segui-los ou fazer da maneira que julgar ser a melhor a ser feita, desde que atenda os contratos de API e funcionalidades descritas.

#### Testes
Existem testes pendentes, eles estão marcados como <span style="color:green;">Pending</span>, e devem ser implementados para garantir a cobertura dos trechos de código implementados por você.
Alguns testes já estão passando e outros estão com erro. Com a sua implementação os testes com erro devem passar a funcionar. 
A adição de novos testes é sempre bem-vinda, mas sem alterar os já implementados.


### O que esperamos
- Implementação dos testes faltantes e de novos testes para os métodos/serviços/entidades criados
- Construção das 4 rotas solicitadas
- Implementação de um job para controle dos carrinhos abandonados


### Itens adicionais / Legais de ter
- Utilização de factory na construção dos testes
- Desenvolvimento do docker-compose / dockerização da app

A aplicação já possui um Dockerfile, que define como a aplicação deve ser configurada dentro de um contêiner Docker. No entanto, para completar a dockerização da aplicação, é necessário criar um arquivo `docker-compose.yml`. O arquivo irá definir como os vários serviços da aplicação (por exemplo, aplicação web, banco de dados, etc.) interagem e se comunicam.

- Adicione tratamento de erros para situações excepcionais válidas, por exemplo: garantir que um produto não possa ter quantidade negativa. 

- Se desejar você pode adicionar a configuração faltante no arquivo `docker-compose.yml` e garantir que a aplicação rode de forma correta utilizando Docker. 

## Informações técnicas

### Dependências
- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como executar o projeto

## Executando a app sem o docker
Dado que todas as as ferramentas estão instaladas e configuradas:

Instalar as dependências do:
```bash
bundle install
```

Executar o sidekiq:
```bash
bundle exec sidekiq
```

Executar projeto:
```bash
bundle exec rails server
```

Executar os testes:
```bash
bundle exec rspec
```

### Como enviar seu projeto
Salve seu código em um versionador de código (GitHub, GitLab, Bitbucket) e nos envie o link publico. Se achar necessário, informe no README as instruções para execução ou qualquer outra informação relevante para correção/entendimento da sua solução.


🧠 Minha Implementação — Desafio Técnico RD Station 2024

Desenvolvido por Munick Nayara Freitas de Souza
📍 Saskatoon – SK (Canadá)
📧 [munick.freitas@hotmail.com](mailto:munick.freitas@hotmail.com)

🌐 [github.com/municksouza](https://github.com/municksouza)

Desenvolvido com foco em clareza, performance e escalabilidade — Desafio técnico RD Station 2024.

🚀 Visão Geral

Esta aplicação implementa uma API RESTful para gerenciamento completo de um carrinho de compras em e-commerce, garantindo integração entre produtos, carrinho e sessões de usuário.
O projeto foi desenvolvido em Ruby on Rails 7.1, com PostgreSQL 16, Redis 7, Sidekiq + Sidekiq-Cron e suporte completo a Docker Compose.

⚙️ Arquitetura e Design da Solução

Rails API-only: estrutura enxuta e voltada à performance;

Controllers limpos: toda a lógica de negócio é centralizada nos models;

FactoryBot + RSpec: garantem isolamento e previsibilidade nos testes;

Sidekiq-Cron Job: responsável por marcar carrinhos abandonados (3 h) e removê-los após 7 dias;

ActiveRecord Transactions: consistência de dados ao adicionar ou remover itens;

Enum status do carrinho (active, abandoned, expired) facilita consultas;

Tratamento de erros e validações adicionais, impedindo quantidades negativas e carrinhos inválidos.

🔍 Principais Funcionalidades

| Recurso | Descrição |
| --- | --- |
| POST /cart | Cria o carrinho (caso não exista) e adiciona o produto. |
| GET /cart | Retorna todos os produtos e o total do carrinho. |
| POST /cart/add_item | Atualiza a quantidade de um produto já existente. |
| DELETE /cart/:product_id | Remove um produto específico do carrinho. |
| Sidekiq Job | Marca como “abandonado” (> 3 h) e remove (> 7 dias). |

Todos os endpoints seguem os contratos do README oficial RD Station e foram testados via curl e RSpec.

🧪 Testes e Qualidade de Código

RSpec executa 32 exemplos, 0 falhas (✅ 100% passing).

Testes de modelo: Cart, Product, CartItem.

Testes de rota: validação completa dos endpoints REST.

Testes de integração: garantem comportamento esperado da sessão do usuário.

FactoryBot: usado no spec/support/factory_bot.rb para gerar dados limpos e reutilizáveis.

Motivo dos suportes (test support): garantir que os helpers e as factories estejam carregados automaticamente, melhorando a velocidade e a organização dos testes.

Performance: os testes foram otimizados para evitar excesso de criação de objetos e uso de banco em loop.
Curl tests: confirmam que os endpoints seguem exatamente as respostas esperadas do desafio (original payload).

🐳 Execução via Docker Compose
docker-compose up --build

O docker-compose.yml inclui os serviços:

web → Rails API app

db → PostgreSQL 16

redis → Redis 7

test → container para rodar RSpec

🧭 Execução Local (padrão)
bundle install
bundle exec rails db:prepare
bundle exec sidekiq
bundle exec rails s
bundle exec rspec

🔐 Segurança e Boas Práticas

Uso de variáveis de ambiente para credenciais sensíveis.

Middleware de sessão segura (armazenamento de ID do carrinho via cookies).

Validações de quantidade ≥ 1 em todos os endpoints.

Proteção CSRF e configuração de headers seguindo as melhores práticas Rails.

📈 Resultados e Conclusão

O projeto atingiu todos os requisitos funcionais e técnicos solicitados:
✅ 4 rotas principais implementadas
✅ Job de limpeza automática com Sidekiq
✅ Testes automatizados e suporte completo FactoryBot
✅ Docker Compose operacional

Foco principal: código legível, performático e fácil de manter, seguindo os princípios do time de Engenharia da RD Station.