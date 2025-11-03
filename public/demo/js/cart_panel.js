document.addEventListener('DOMContentLoaded', () => {
  const cartToggle = document.getElementById('cart-toggle');
  const cartPanel = document.getElementById('cart-panel');
  const backBtn = document.getElementById('back-home');

  if (!cartToggle || !cartPanel) {
    console.warn('⚠️ Elementos do carrinho não encontrados no DOM.');
    return;
  }

  // Abre e fecha o carrinho
  cartToggle.addEventListener('click', () => {
    cartPanel.classList.toggle('active');
    console.log('🛒 Carrinho alternado');
  });

  // Fecha ao clicar em “Voltar”
  if (backBtn) {
    backBtn.addEventListener('click', () => {
      cartPanel.classList.remove('active');
      console.log('⬅️ Carrinho fechado');
    });
  } else {
    console.warn('⚠️ Botão de voltar não encontrado.');
  }
});
