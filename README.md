🧠 Desafio Técnico RD Station
🛒 Carrinho de Compras (2024)

Autora: Munick Nayara Freitas de Souza
📍 Saskatoon – SK, Canadá
🌐 https://github.com/municksouza

🎯 Visão Geral

Este projeto implementa uma API RESTful para gerenciamento de carrinho de compras em um e-commerce, desenvolvida como parte do Desafio Técnico da RD Station (2024).

O foco principal da solução foi:

clareza e legibilidade do código

separação correta de responsabilidades

regras de negócio centralizadas no domínio

cobertura completa de testes

comportamento realista de um carrinho (sessão, abandono, limpeza automática)

Além da API, o projeto inclui uma interface frontend de demonstração, utilizada apenas para simular o consumo da API em um cenário real.

🚀 Stack Técnica
Camada	Tecnologia
Backend	Ruby 3.3.1 · Rails 7.1 (API-only)
Banco de Dados	PostgreSQL 16
Processos Assíncronos	Redis 7 · Sidekiq · Sidekiq-Cron
Testes	RSpec · FactoryBot
Infraestrutura	Docker · Docker Compose
Frontend (Demo)	HTML · CSS · JavaScript (esbuild)
⚙️ Arquitetura e Decisões de Design

Aplicação Rails API-only, priorizando simplicidade e performance

Carrinho baseado em sessão, com o cart_id persistido via cookies

Regras de negócio concentradas no model Cart, evitando duplicação em controllers ou frontend

Operações atômicas com transações e locks (with_lock)

Jobs em background para controle do ciclo de vida dos carrinhos abandonados

Validações claras e previsíveis, alinhadas ao comportamento esperado de um e-commerce real

Estratégia de Atualização de Quantidade

O endpoint /api/cart/add_item foi projetado para aceitar quantidades positivas ou negativas, desde que o produto já exista no carrinho.

Comportamento:

+n → incrementa a quantidade do produto

-n → decrementa a quantidade do produto

quantidade final <= 0 → o item é removido automaticamente do carrinho

Essa decisão:

evita múltiplos endpoints para a mesma operação

reduz lógica duplicada no frontend

mantém as regras centralizadas no domínio

facilita a manutenção e evolução da API

🔍 Endpoints da API
Método	Rota	Descrição
POST	/api/cart	Cria um carrinho caso não exista na sessão
POST	/api/cart/add_item	Adiciona ou altera a quantidade de um produto
GET	/api/cart	Retorna os itens do carrinho e o valor total
DELETE	/api/cart/:product_id	Remove um produto específico do carrinho
⏰ Controle de Carrinhos Abandonados (Sidekiq)

Um carrinho é considerado abandonado quando:

Sem interação por mais de 3 horas → marcado como abandoned

Marcado como abandonado há mais de 7 dias → removido definitivamente

Esse processo é gerenciado por um job agendado do Sidekiq, executado periodicamente.

:schedule:
  mark_carts_as_abandoned_job:
    cron: "*/30 * * * *"
    class: "MarkCartAsAbandonedJob"


O job é executado a cada 30 minutos.

🧪 Testes e Qualidade de Código

✅ 32 testes RSpec — 0 falhas

Cobertura inclui:

Models (Cart, CartItem, Product)

Requests (comportamento da API)

Rotas

Casos de erro e validações

bundle exec rspec


Os testes utilizam FactoryBot, garantindo clareza e reutilização dos cenários.

🧪 Testes Manuais via cURL

Os testes manuais da API utilizam cookies persistentes, simulando corretamente uma sessão de usuário.

Criar arquivo de cookies
touch cookies.txt

Adicionar produto ao carrinho
curl -X POST http://localhost:3000/api/cart/add_item \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "quantity": 2}' \
  -c cookies.txt

Consultar carrinho
curl -X GET http://localhost:3000/api/cart -b cookies.txt

Remover produto
curl -X DELETE http://localhost:3000/api/cart/1 -b cookies.txt

🎨 Frontend de Demonstração (Opcional)

Localizado em /public/demo, o frontend foi criado apenas para demonstrar o consumo da API em um fluxo real de e-commerce.

Funcionalidades:

listagem dinâmica de produtos

carrinho lateral com atualização em tempo real

incremento e decremento de quantidade

layout responsivo

Estrutura:

public/demo/
├── index.html
├── styles/
└── dist/bundle.js


Arquivos de demonstração:

demo_cart_frontend.gif

demo_cart.mp4

🐳 Execução com Docker
docker-compose up --build


Serviços:

Serviço	Descrição
web	API Rails
db	PostgreSQL
redis	Redis
test	Ambiente RSpec
🧭 Execução Local (Sem Docker)
bundle install
bundle exec rails db:prepare
bundle exec sidekiq
bundle exec rails s
bundle exec rspec

🔐 Segurança e Validações

não é permitido adicionar itens novos com quantidade ≤ 0

quantidades negativas são aceitas apenas para itens já existentes

remoção automática quando a quantidade final é ≤ 0

proteção CSRF habilitada

isolamento por sessão

📈 Considerações Finais

Todas as funcionalidades solicitadas no desafio foram implementadas

Testes pendentes foram concluídos

Testes adicionais foram adicionados

Jobs de limpeza e abandono funcionam conforme especificação

Código prioriza clareza, manutenibilidade e previsibilidade

Esta solução segue o princípio destacado pela RD Station:
projetar código para ser mais fácil de entender, não apenas mais fácil de escrever.

👩‍💻 Autora

Munick Nayara Freitas de Souza
📍 Saskatoon – SK, Canadá
🌐 https://github.com/municksouza


English Version 


🧠 RD Station
🛒 E-commerce Cart Challenge (2024)

Author: Munick Nayara Freitas de Souza
📍 Saskatoon – SK, Canada
🌐 https://github.com/municksouza

🎯 Overview

This project implements a RESTful API for an e-commerce shopping cart, developed as part of the RD Station Technical Challenge 2024.

The main goals were:

clarity over cleverness

clean, readable code

correct domain modeling

solid test coverage

real-world behavior (sessions, background jobs, cart lifecycle)

A small frontend demo is also included to simulate real usage of the API.

🚀 Tech Stack
Layer	Technology
Backend	Ruby 3.3.1 · Rails 7.1 (API-only)
Database	PostgreSQL 16
Background Jobs	Redis 7 · Sidekiq · Sidekiq-Cron
Testing	RSpec · FactoryBot
Infra	Docker · Docker Compose
Frontend Demo	HTML · CSS · JavaScript (esbuild)
⚙️ Architecture & Design Decisions

API-only Rails app focused on performance and simplicity

Session-based cart (cart ID stored in cookies)

Domain-driven logic centralized in Cart model

Atomic operations using ActiveRecord transactions and locks

Background jobs manage abandoned carts lifecycle

Clear business rules, enforced at the domain level (not duplicated in controllers or frontend)

Quantity Update Strategy

The endpoint /api/cart/add_item accepts positive and negative quantities only when the product already exists in the cart.

Behavior:

+n → increases quantity

-n → decreases quantity

resulting quantity <= 0 → item is automatically removed

This decision:

keeps the API expressive

avoids extra endpoints

centralizes rules in the domain layer

prevents client-side duplication of business logic

🔍 API Endpoints
Method	Route	Description
POST	/api/cart	Creates a cart (if none exists in session)
POST	/api/cart/add_item	Adds or updates a product quantity
GET	/api/cart	Returns cart items and total
DELETE	/api/cart/:product_id	Removes a product from the cart
⏰ Abandoned Cart Lifecycle (Sidekiq)

A cart is considered abandoned when:

No interaction for 3 hours → marked as abandoned

Abandoned for 7 days → permanently removed

This process is handled by a scheduled Sidekiq job.

:schedule:
  mark_carts_as_abandoned_job:
    cron: "*/30 * * * *"
    class: "MarkCartAsAbandonedJob"


Runs every 30 minutes.

🧪 Tests & Quality

✅ 32 RSpec examples — 0 failures

Coverage includes:

Models (Cart, CartItem, Product)

Request specs (API behavior)

Routing specs

Edge cases and invalid states

bundle exec rspec


Factories are used throughout for clarity and maintainability.

🧪 Manual Testing via cURL

Session persistence is handled using cookies.

Create cookie file
touch cookies.txt

Add product
curl -X POST http://localhost:3000/api/cart/add_item \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "quantity": 2}' \
  -c cookies.txt

View cart
curl -X GET http://localhost:3000/api/cart -b cookies.txt

Remove product
curl -X DELETE http://localhost:3000/api/cart/1 -b cookies.txt

🎨 Frontend Demo (Optional)

Located at /public/demo, the frontend simulates a real shopping experience using the API.

Features:

product listing

side cart with real-time updates

quantity increment/decrement

responsive layout

Assets:

public/demo/
├── index.html
├── styles/
└── dist/bundle.js

Demo Media

demo_cart_frontend.gif

demo_cart.mp4

🐳 Running with Docker
docker-compose up --build


Services:

Service	Description
web	Rails API
db	PostgreSQL
redis	Redis
test	RSpec environment
🧭 Running Locally (Without Docker)
bundle install
bundle exec rails db:prepare
bundle exec sidekiq
bundle exec rails s
bundle exec rspec

🔐 Security & Validations

quantity must be ≥ 1 for new items

negative quantities allowed only for existing items

CSRF protection enabled

session-based isolation

strong parameter validation

📈 Final Notes

All required features were implemented

Pending tests were completed

Additional tests were added

Background jobs behave as specified

Code prioritizes readability and maintainability

This solution reflects the engineering principles described by RD Station: code that is easier to understand, not just easier to write.

👩‍💻 Author

Munick Nayara Freitas de Souza
📍 Saskatoon – SK, Canada
🌐 https://github.com/municksouza