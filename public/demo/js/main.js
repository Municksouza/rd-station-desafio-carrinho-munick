import { renderProducts } from './products.js';
import { renderCart, toggleCart } from './cart.js';

document.addEventListener('DOMContentLoaded', async () => {
  await renderProducts();
  await renderCart();

  document.getElementById('cart-toggle').addEventListener('click', toggleCart);
  document.getElementById('checkout-btn').addEventListener('click', () => {
    alert('🚀 Esse é apenas um demo visual, mas a API está 100% funcional!');
  });
});
