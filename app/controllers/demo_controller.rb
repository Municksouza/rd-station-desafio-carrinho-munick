class DemoController < ApplicationController
  def index
    # Renderiza o arquivo HTML diretamente da pasta public/demo
    render file: Rails.root.join("public", "demo", "index.html"), layout: false
  end
end
