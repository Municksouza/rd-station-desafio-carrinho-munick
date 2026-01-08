# 🧠 Desafio Técnico RD Station
## 🛒 Carrinho de Compras (2024)

![Ruby](https://img.shields.io/badge/Ruby-3.3.1-red?logo=ruby)
![Rails](https://img.shields.io/badge/Rails-7.1.3.2-crimson?logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-7.0-darkred?logo=redis)
![Sidekiq](https://img.shields.io/badge/Sidekiq-active-green?logo=ruby)
![RSpec](https://img.shields.io/badge/RSpec-24%20tests%20passing-brightgreen?logo=rspec)
![Docker](https://img.shields.io/badge/Docker-ready-blue?logo=docker)

**Autora:** Munick Nayara Freitas de Souza  
📍 Saskatoon – SK, Canadá  
🌐 [github.com/municksouza](https://github.com/municksouza)

---

## 🎯 Visão Geral

Este projeto implementa uma **API RESTful** para gerenciamento de carrinho de compras em um e-commerce, desenvolvida como parte do **Desafio Técnico da RD Station (2024)**.

O foco principal da solução foi:

- ✅ Clareza e legibilidade do código
- ✅ Separação correta de responsabilidades
- ✅ Regras de negócio centralizadas no domínio
- ✅ Cobertura completa de testes
- ✅ Comportamento realista de um carrinho (sessão, abandono, limpeza automática)

Além da API, o projeto inclui uma interface frontend de demonstração, utilizada apenas para simular o consumo da API em um cenário real.

---

## 🚀 Stack Técnica

| Camada | Tecnologia |
|--------|------------|
| **Backend** | Ruby 3.3.1 · Rails 7.1 (API-only) |
| **Banco de Dados** | PostgreSQL 16 |
| **Processos Assíncronos** | Redis 7 · Sidekiq · Sidekiq-Cron |
| **Testes** | RSpec · FactoryBot |
| **Infraestrutura** | Docker · Docker Compose |
| **Frontend (Demo)** | HTML · CSS · JavaScript (esbuild) |

---

## ⚙️ Arquitetura e Decisões de Design

- **Aplicação Rails API-only**, priorizando simplicidade e performance
- **Carrinho baseado em sessão**, com o `cart_id` persistido via cookies
- **Regras de negócio concentradas no model Cart**, evitando duplicação em controllers ou frontend
- **Operações atômicas** com transações e locks (`with_lock`)
- **Jobs em background** para controle do ciclo de vida dos carrinhos abandonados
- **Validações claras e previsíveis**, alinhadas ao comportamento esperado de um e-commerce real

### Estratégia de Atualização de Quantidade

O endpoint `/api/cart/add_item` foi projetado para aceitar quantidades positivas ou negativas, desde que o produto já exista no carrinho.

**Comportamento:**

- `+n` → incrementa a quantidade do produto
- `-n` → decrementa a quantidade do produto
- `quantidade final <= 0` → o item é removido automaticamente do carrinho

**Essa decisão:**

- Evita múltiplos endpoints para a mesma operação
- Reduz lógica duplicada no frontend
- Mantém as regras centralizadas no domínio
- Facilita a manutenção e evolução da API

---

## 🔍 Endpoints da API

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/api/cart` | Cria um carrinho caso não exista na sessão |
| `POST` | `/api/cart/add_item` | Adiciona ou altera a quantidade de um produto |
| `GET` | `/api/cart` | Retorna os itens do carrinho e o valor total |
| `DELETE` | `/api/cart/:product_id` | Remove um produto específico do carrinho |

---

## ⏰ Controle de Carrinhos Abandonados (Sidekiq)

Um carrinho é considerado abandonado quando:

- **Sem interação por mais de 3 horas** → marcado como `abandoned`
- **Marcado como abandonado há mais de 7 dias** → removido definitivamente

Esse processo é gerenciado por um job agendado do Sidekiq, executado periodicamente.

**Configuração no `config/sidekiq.yml`:**

```yaml
:schedule:
  mark_carts_as_abandoned_job:
    cron: "*/30 * * * *"
    class: "MarkCartAsAbandonedJob"
```

O job é executado **a cada 30 minutos**.

---

## 🧪 Testes e Qualidade de Código

✅ **24 testes RSpec — 0 falhas**

**Cobertura inclui:**

- Models (Cart, CartItem, Product)
- Requests (comportamento da API)
- Rotas
- Casos de erro e validações

**Executar testes:**

```bash
bundle exec rspec
```

Os testes utilizam **FactoryBot**, garantindo clareza e reutilização dos cenários.

---

## 🧪 Testes Manuais via cURL

Os testes manuais da API utilizam cookies persistentes, simulando corretamente uma sessão de usuário.

### Criar arquivo de cookies

```bash
touch cookies.txt
```

### Adicionar produto ao carrinho

```bash
curl -X POST http://localhost:3000/api/cart/add_item \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "quantity": 2}' \
  -c cookies.txt
```

### Consultar carrinho

```bash
curl -X GET http://localhost:3000/api/cart -b cookies.txt
```

### Remover produto

```bash
curl -X DELETE http://localhost:3000/api/cart/1 -b cookies.txt
```

---

## 🎨 Frontend de Demonstração (Opcional)

Localizado em `/public/demo`, o frontend foi criado apenas para demonstrar o consumo da API em um fluxo real de e-commerce.

**Funcionalidades:**

- Listagem dinâmica de produtos
- Carrinho lateral com atualização em tempo real
- Incremento e decremento de quantidade
- Layout responsivo

**Estrutura:**

```
public/demo/
├── index.html
├── styles/
│   ├── base.css
│   └── components.css
├── js/
│   ├── api.js
│   ├── cart.js
│   ├── products.js
│   └── ...
└── dist/
    └── bundle.js
```

**Arquivos de demonstração:**

- `demo_cart_frontend.gif`
- `demo_cart.mp4`

---

## 🐳 Execução com Docker

```bash
docker-compose up --build
```

**Serviços:**

| Serviço | Descrição |
|---------|-----------|
| `web` | API Rails |
| `db` | PostgreSQL |
| `redis` | Redis |
| `test` | Ambiente RSpec |

---

## 🧭 Execução Local (Sem Docker)

```bash
# Instalar dependências
bundle install

# Preparar banco de dados
bundle exec rails db:prepare

# Executar Sidekiq (em terminal separado)
bundle exec sidekiq

# Executar servidor Rails (em terminal separado)
bundle exec rails s

# Executar testes
bundle exec rspec
```

---

## 🔐 Segurança e Validações

- ✅ Não é permitido adicionar itens novos com quantidade ≤ 0
- ✅ Quantidades negativas são aceitas apenas para itens já existentes
- ✅ Remoção automática quando a quantidade final é ≤ 0
- ✅ Proteção CSRF habilitada
- ✅ Isolamento por sessão

---

## 📈 Considerações Finais

- ✅ Todas as funcionalidades solicitadas no desafio foram implementadas
- ✅ Testes pendentes foram concluídos
- ✅ Testes adicionais foram adicionados
- ✅ Jobs de limpeza e abandono funcionam conforme especificação
- ✅ Código prioriza clareza, manutenibilidade e previsibilidade

Esta solução segue o princípio destacado pela RD Station:

> **Projetar código para ser mais fácil de entender, não apenas mais fácil de escrever.**

---

## 👩‍💻 Autora

**Munick Nayara Freitas de Souza**  
📍 Saskatoon – SK, Canadá  
🌐 [github.com/municksouza](https://github.com/municksouza)

---

# English Version

## 🧠 RD Station E-commerce Cart Challenge (2024)

**Author:** Munick Nayara Freitas de Souza  
📍 Saskatoon – SK, Canada  
🌐 [github.com/municksouza](https://github.com/municksouza)

---

## 🎯 Overview

This project implements a **RESTful API** for an e-commerce shopping cart, developed as part of the **RD Station Technical Challenge 2024**.

**The main goals were:**

- ✅ Clarity over cleverness
- ✅ Clean, readable code
- ✅ Correct domain modeling
- ✅ Solid test coverage
- ✅ Real-world behavior (sessions, background jobs, cart lifecycle)

A small frontend demo is also included to simulate real usage of the API.

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Ruby 3.3.1 · Rails 7.1 (API-only) |
| **Database** | PostgreSQL 16 |
| **Background Jobs** | Redis 7 · Sidekiq · Sidekiq-Cron |
| **Testing** | RSpec · FactoryBot |
| **Infra** | Docker · Docker Compose |
| **Frontend Demo** | HTML · CSS · JavaScript (esbuild) |

---

## ⚙️ Architecture & Design Decisions

- **API-only Rails app** focused on performance and simplicity
- **Session-based cart** (cart ID stored in cookies)
- **Domain-driven logic** centralized in Cart model
- **Atomic operations** using ActiveRecord transactions and locks
- **Background jobs** manage abandoned carts lifecycle
- **Clear business rules**, enforced at the domain level (not duplicated in controllers or frontend)

### Quantity Update Strategy

The endpoint `/api/cart/add_item` accepts positive and negative quantities only when the product already exists in the cart.

**Behavior:**

- `+n` → increases quantity
- `-n` → decreases quantity
- `resulting quantity <= 0` → item is automatically removed

**This decision:**

- Keeps the API expressive
- Avoids extra endpoints
- Centralizes rules in the domain layer
- Prevents client-side duplication of business logic

---

## 🔍 API Endpoints

| Method | Route | Description |
|--------|-------|-------------|
| `POST` | `/api/cart` | Creates a cart (if none exists in session) |
| `POST` | `/api/cart/add_item` | Adds or updates a product quantity |
| `GET` | `/api/cart` | Returns cart items and total |
| `DELETE` | `/api/cart/:product_id` | Removes a product from the cart |

---

## ⏰ Abandoned Cart Lifecycle (Sidekiq)

A cart is considered abandoned when:

- **No interaction for 3 hours** → marked as abandoned
- **Abandoned for 7 days** → permanently removed

This process is handled by a scheduled Sidekiq job.

**Configuration in `config/sidekiq.yml`:**

```yaml
:schedule:
  mark_carts_as_abandoned_job:
    cron: "*/30 * * * *"
    class: "MarkCartAsAbandonedJob"
```

Runs **every 30 minutes**.

---

## 🧪 Tests & Quality

✅ **24 RSpec examples — 0 failures**

**Coverage includes:**

- Models (Cart, CartItem, Product)
- Request specs (API behavior)
- Routing specs
- Edge cases and invalid states

**Run tests:**

```bash
bundle exec rspec
```

Factories are used throughout for clarity and maintainability.

---

## 🧪 Manual Testing via cURL

Session persistence is handled using cookies.

### Create cookie file

```bash
touch cookies.txt
```

### Add product

```bash
curl -X POST http://localhost:3000/api/cart/add_item \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "quantity": 2}' \
  -c cookies.txt
```

### View cart

```bash
curl -X GET http://localhost:3000/api/cart -b cookies.txt
```

### Remove product

```bash
curl -X DELETE http://localhost:3000/api/cart/1 -b cookies.txt
```

---

## 🎨 Frontend Demo (Optional)

Located at `/public/demo`, the frontend simulates a real shopping experience using the API.

**Features:**

- Product listing
- Side cart with real-time updates
- Quantity increment/decrement
- Responsive layout

**Assets:**

```
public/demo/
├── index.html
├── styles/
│   ├── base.css
│   └── components.css
├── js/
│   ├── api.js
│   ├── cart.js
│   ├── products.js
│   └── ...
└── dist/
    └── bundle.js
```

**Demo Media:**

- `demo_cart_frontend.gif`
- `demo_cart.mp4`

---

## 🐳 Running with Docker

```bash
docker-compose up --build
```

**Services:**

| Service | Description |
|---------|-------------|
| `web` | Rails API |
| `db` | PostgreSQL |
| `redis` | Redis |
| `test` | RSpec environment |

---

## 🧭 Running Locally (Without Docker)

```bash
# Install dependencies
bundle install

# Prepare database
bundle exec rails db:prepare

# Run Sidekiq (in separate terminal)
bundle exec sidekiq

# Run Rails server (in separate terminal)
bundle exec rails s

# Run tests
bundle exec rspec
```

---

## 🔐 Security & Validations

- ✅ Quantity must be ≥ 1 for new items
- ✅ Negative quantities allowed only for existing items
- ✅ CSRF protection enabled
- ✅ Session-based isolation
- ✅ Strong parameter validation

---

## 📈 Final Notes

- ✅ All required features were implemented
- ✅ Pending tests were completed
- ✅ Additional tests were added
- ✅ Background jobs behave as specified
- ✅ Code prioritizes readability and maintainability

This solution reflects the engineering principles described by RD Station:

> **Code that is easier to understand, not just easier to write.**

---

## 👩‍💻 Author

**Munick Nayara Freitas de Souza**  
📍 Saskatoon – SK, Canada  
🌐 [github.com/municksouza](https://github.com/municksouza)
