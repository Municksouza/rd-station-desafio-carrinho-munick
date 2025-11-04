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
async function handleQuantityChange(item, change) {
  const newQty = item.quantity + change;
  if (newQty < 1) return; // evita zero ou negativo
  await API.updateCartItem(item.id, change);
  await renderCart();
}

async function handleRemoveItem(productId) {
  await API.removeFromCart(productId);
  await renderCart();
}

/**
 * Alterna o painel lateral do carrinho.
 */
export function toggleCart() {
  document.getElementById('cart-panel').classList.toggle('show');
}
