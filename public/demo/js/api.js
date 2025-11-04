/**
 * api.js — Camada de comunicação com a API Rails.
 * Todas as requisições passam por aqui, garantindo
 * padronização e tratamento de erros.
 *
 * Endpoints (namespace /api):
 *  - GET    /api/products
 *  - GET    /api/cart
 *  - POST   /api/cart
 *  - POST   /api/cart/add_item
 *  - DELETE /api/cart/:id
 */

export const API = {
  /**
   * Método base para todas as requisições HTTP.
   * Lida com erros e converte a resposta para JSON automaticamente.
   */
  async request(url, options = {}) {
    const config = {
      headers: { 'Content-Type': 'application/json' },
      credentials: 'same-origin', // mantém cookies de sessão
      ...options,
    };

    try {
      const response = await fetch(url, config);

      // Lida com erros HTTP
      if (!response.ok) {
        const message = `Erro ${response.status}: ${response.statusText}`;
        console.error(`❌ [API Error] ${message}`);
        throw new Error(message);
      }

      // Retorna o JSON parseado (ou objeto vazio se falhar)
      const data = await response.json().catch(() => ({}));
      return data;

    } catch (error) {
      console.error("🚨 Falha na requisição:", error);
      alert("⚠️ Erro ao se comunicar com o servidor. Tente novamente.");
      return { products: [], total_price: 0 };
    }
  },

  // === Produtos ===

  /**
   * Busca todos os produtos disponíveis.
   * @returns {Promise<Array>} Lista de produtos.
   */
  getProducts() {
    return this.request('/api/products');
  },

  /**
   * Busca um produto específico (opcional).
   * @param {number} id - ID do produto.
   * @returns {Promise<Object>} Produto.
   */
  getProduct(id) {
    return this.request(`/api/products/${id}`);
  },

  // === Carrinho ===

  /**
   * Retorna o carrinho atual (cria um se não existir).
   * @returns {Promise<Object>} Carrinho.
   */
  getCart() {
    return this.request('/api/cart');
  },

/**
 * Adiciona um produto ao carrinho.
 * Cria o carrinho automaticamente se necessário.
 * @param {number} productId - ID do produto.
 * @param {number} quantity - Quantidade desejada.
 * @returns {Promise<Object>} Carrinho atualizado.
 */
addToCart(productId, quantity = 1) {
  return this.request('/api/cart/add_item', {
    method: 'POST',
    body: JSON.stringify({ product_id: productId, quantity }),
  });
},

/**
 * Atualiza a quantidade de um item existente no carrinho.
 * @param {number} productId - ID do produto.
 * @param {number} quantity - Quantidade adicional.
 * @returns {Promise<Object>} Carrinho atualizado.
 */
 updateCartItem(productId, quantityChange) {
    return this.request('/api/cart/add_item', {
      method: 'POST',
      body: JSON.stringify({ product_id: productId, quantity: quantityChange }),
    });
  },

  /**
   * Remove um produto específico do carrinho.
   * @param {number} productId - ID do produto.
   * @returns {Promise<Object>} Carrinho atualizado.
   */
  removeFromCart(productId) {
    return this.request(`/api/cart/${productId}`, {
      method: 'DELETE',
    });
  },
};
