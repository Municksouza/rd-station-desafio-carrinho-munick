const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
const defaultHeaders = token ? { 'X-CSRF-Token': token } : {};

async function getJSON(url) {
    const res = await fetch(url, { credentials: 'same-origin' });
    if (!res.ok) throw new Error(await res.text());
    return res.json();
}
async function postJSON(url, body) {
    const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(body),
    });
    if (!res.ok) throw new Error(await res.text());
    return res.json();
}
async function del(url) {
    const res = await fetch(url, { method: 'DELETE', credentials: 'same-origin' });
    if (!res.ok) throw new Error(await res.text());
    return res.json();
}

// Interface (UI)
const $ = (sel) => document.querySelector(sel);
const productsTBody = $('#products-table tbody');
const cartTBody = $('#cart-table tbody');
const cartTotal = $('#cart-total');

function renderProducts(list) {
    productsTBody.innerHTML = '';
    list.forEach((p) => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${p.id}</td>
            <td>${p.name}</td>
            <td>${Number(p.price).toFixed(2)}</td>
            <td>
                <button class="btn btn-small" data-add="${p.id}">Adicionar (qtd 1)</button>
            </td>
        `;
        productsTBody.appendChild(tr);
    });
}

function renderCart(cart) {
    cartTBody.innerHTML = '';
    (cart.products || []).forEach((it) => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${it.id}</td>
            <td>${it.name}</td>
            <td>${it.quantity}</td>
            <td>${Number(it.unit_price).toFixed(2)}</td>
            <td>${Number(it.total_price).toFixed(2)}</td>
            <td class="row gap">
                <button class="btn btn-small" data-inc="${it.id}">+1</button>
                <button class="btn btn-small btn-danger" data-del="${it.id}">Remover</button>
            </td>
        `;
        cartTBody.appendChild(tr);
    });
    cartTotal.textContent = `Total: ${Number(cart.total_price || 0).toFixed(2)}`;
}

// ações
async function loadProducts() {
    const list = await getJSON('/products');
    renderProducts(list);
}
async function loadCart() {
    try {
        const cart = await getJSON('/cart');
        renderCart(cart);
    } catch (_e) {
        // o carrinho pode não existir ainda — renderiza vazio
        renderCart({ products: [], total_price: 0 });
    }
}

async function addToCart(product_id, quantity) {
    // POST /cart cria/usa carrinho e adiciona item
    const cart = await postJSON('/cart', { product_id, quantity });
    renderCart(cart);
}
async function incrementItem(product_id) {
    // POST /cart/add_item incrementa quantidade
    const cart = await postJSON('/cart/add_item', { product_id, quantity: 1 });
    renderCart(cart);
}
async function removeItem(product_id) {
    const cart = await del(`/cart/${product_id}`);
    renderCart(cart);
}

// vincular formulários
$('#form-create-product').addEventListener('submit', async (e) => {
    e.preventDefault();
    const name = $('#pname').value.trim();
    const price = parseFloat($('#pprice').value);
    if (!name || isNaN(price)) return;
    await postJSON('/products', { product: { name, price } });
    $('#pname').value = ''; $('#pprice').value = '';
    await loadProducts();
});

$('#form-add-to-cart').addEventListener('submit', async (e) => {
    e.preventDefault();
    const pid = parseInt($('#product_id').value, 10);
    const qty = parseInt($('#quantity').value, 10);
    if (!pid || !qty || qty <= 0) return alert('Informe product_id e quantidade > 0');
    try {
        await addToCart(pid, qty);
    } catch (err) {
        alert(`Erro: ${err.message}`);
    }
});

// delegação de eventos nas tabelas
productsTBody.addEventListener('click', async (e) => {
    const btn = e.target.closest('button[data-add]');
    if (!btn) return;
    const id = parseInt(btn.dataset.add, 10);
    await addToCart(id, 1);
});
cartTBody.addEventListener('click', async (e) => {
    const inc = e.target.closest('button[data-inc]');
    const delBtn = e.target.closest('button[data-del]');
    if (inc) {
        await incrementItem(parseInt(inc.dataset.inc, 10));
    } else if (delBtn) {
        await removeItem(parseInt(delBtn.dataset.del, 10));
    }
});

// inicialização
(async function init() {
    await loadProducts();
    await loadCart();
})();
