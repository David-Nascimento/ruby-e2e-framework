# frozen_string_literal: true

class ServerestHomePage < ServerestPage
  ADMIN_PATH = '/admin/home'

  # Espera a navegação para a home do administrador; estoura Timeout se não chegar
  def carregada?
    @wait.until { current_path == ADMIN_PATH }
  end
end
