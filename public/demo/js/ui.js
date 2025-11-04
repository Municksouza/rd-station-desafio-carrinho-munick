/**
 * ui.js — Responsável por toda a interação visual e manipulação do DOM.
 * Refatorado com base nos utilitários do dom.js para um código mais limpo e seguro.
 */
import { $, $$, el, mount } from './dom.js';

const UI = (() => {
  // Seletores principais
  const selectors = {
    cartPanel: $('#cart-panel'),
    cartCount: $('#cart-count'),
    cartItems: $('#cart-items'),
    cartTotal: $('#cart-total'),
    productList: $('#products-list'),
  };

  /**
   * Alterna a visibilidade do painel do carrinho.
   */
  function toggleCart() {
    selectors.cartPanel.classList.toggle('show');
  }

  /**
   * Renderiza a lista de produtos na interface.
   * @param {Array} products - Lista de produtos.
   */
  function renderProducts(products) {
    if (!products.length) {
      mount(selectors.productList, el('p', {}, 'Nenhum produto disponível.'));
      return;
    }

    const productElements = products.map((p) =>
      el('div', { class: 'product' }, [
        el('img', {
          src: `https://picsum.photos/seed/${p.id}/300/200`,
          alt: p.name,
          class: 'product-img',
        }),
        el('h3', {}, p.name),
        el('p', {}, el('strong', {}, `R$ ${p.price.toFixed(2)}`)),
        el('button', {
          class: 'add-btn',
          onclick: () => Cart.add(p.id),
        }, 'Adicionar ao carrinho'),
      ])
    );

    mount(selectors.productList, productElements);
  }

  /**
   * Renderiza o carrinho (itens, quantidade e total).
   * @param {Object} cart - Objeto contendo os produtos e total.
   */
  function renderCart(cart) {
    selectors.cartCount.textContent = cart.products.length;
    selectors.cartTotal.textContent = cart.total_price.toFixed(2);

    if (!cart.products.length) {
      mount(selectors.cartItems, el('p', {}, 'Carrinho vazio 🛒'));
      return;
    }

    const cartElements = cart.products.map((item) =>
      el('div', { class: 'cart-item' }, [
        el('span', {}, `${item.name} x${item.quantity}`),
        el('span', {}, `R$ ${item.total_price.toFixed(2)}`),
        el('button', {
          class: 'remove-btn',
          onclick: () => Cart.remove(item.id),
        }, '✕'),
      ])
    );

    mount(selectors.cartItems, cartElements);
  }

  /**
   * Ação de checkout (demonstração visual).
   */
  function checkout() {
    alert('🚀 Esse é um demo visual. A API está 100% funcional, mas o pagamento é simbólico :)');
  }

  return { toggleCart, renderProducts, renderCart, checkout };
})();

export default UI;
