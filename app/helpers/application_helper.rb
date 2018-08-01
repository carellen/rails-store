module ApplicationHelper
  def document_button_class(document)
    document.posting? ? 'btn-success' : 'btn-danger'
  end
end
