import { el, mount } from './dom.js';
import { API } from './api.js';

export async function renderCart() {
  const cartPanel = document.getElementById('cart-panel');
  const cartItems = document.getElementById('cart-items');
  const cartCount = document.getElementById('cart-count');
  const cartTotal = document.getElementById('cart-total');

  // Busca o carrinho
  const cart = await API.getCart();

  // Atualiza contadores
  cartCount.textContent = cart.products?.length || 0;
  cartTotal.textContent = (cart.total_price || 0).toFixed(2);

  // Limpa o conteúdo anterior
  cartItems.innerHTML = '';

  if (!cart.products || cart.products.length === 0) {
    mount(cartItems, el('p', {}, 'Carrinho vazio 🛒'));
    return;
  }

  // Renderiza os itens
  const items = cart.products.map((item) => {
    const decreaseBtn = el('button', {
      class: 'qty-btn',
      onclick: () => handleQuantityChange(item, -1)
    }, '−');

    const qtyDisplay = el('span', { class: 'qty' }, item.quantity.toString());

    const increaseBtn = el('button', {
      class: 'qty-btn',
      onclick: () => handleQuantityChange(item, 1)
    }, '+');

    const removeBtn = el('button', {
      class: 'remove-btn',
      onclick: () => handleRemoveItem(item.id)
    }, '✕');

    const quantityControls = el('div', { class: 'quantity-controls' }, [
      decreaseBtn, qtyDisplay, increaseBtn
    ]);

    return el('div', { class: 'cart-item' }, [
      el('span', {}, item.name),
      quantityControls,
      el('span', {}, `R$ ${Number(item.total_price).toFixed(2)}`),
      removeBtn
    ]);
  });

  mount(cartItems, items);
}

// Funções auxiliares

/**
 * Atualiza a quantidade de um item no carrinho.
 * @param {Object} item - Item do carrinho (contém id, quantity, etc.)
 * @param {number} delta - Quantidade a adicionar/subtrair (ex: +1 ou -1)
 */
async function handleQuantityChange(item, delta) {
  try {
    // O backend agora aceita valores negativos e remove automaticamente se quantidade <= 0
    await API.updateCartItem(item.id, delta);
    await renderCart();
  } catch (error) {
    console.error('Erro ao atualizar quantidade:', error);
    alert('Erro ao atualizar quantidade do item. Tente novamente.');
  }
}

async function handleRemoveItem(productId) {
  try {
    await API.removeFromCart(productId);
    await renderCart();
  } catch (error) {
    console.error('Erro ao remover item:', error);
    alert('Erro ao remover item. Tente novamente.');
  }
}

/**
 * Alterna o painel lateral do carrinho.
 */
export function toggleCart() {
  document.getElementById('cart-panel').classList.toggle('show');
}
