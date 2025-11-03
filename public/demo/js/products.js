import { el, mount } from './dom.js';
import { API } from './api.js';
import { renderCart } from './cart.js';

export async function renderProducts() {
  const container = document.getElementById('products-list');
  mount(container, el('p', {}, 'Carregando produtos...'));

  const products = await API.getProducts();

  if (!products.length) {
    mount(container, el('p', {}, 'Nenhum produto disponível.'));
    return;
  }

  const items = products.map((p) =>
    el('div', { class: 'product' }, [
      el('img', {
        src: `https://picsum.photos/seed/${p.id}/300/200`,
        alt: p.name,
        class: 'product-img',
      }),
      el('h3', {}, p.name),
      el('p', {}, el('strong', {}, `R$ ${parseFloat(p.price || 0).toFixed(2)}`)),
      el('button', {
        class: 'add-btn',
        onclick: async () => {
          await API.addToCart(p.id);
          await renderCart(); // atualiza o carrinho
        },
      }, 'Adicionar ao carrinho'),
    ])
  );

  mount(container, items);
}
