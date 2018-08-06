class DocumentPostingsController < ApplicationController
  before_action :find_document, except: :index

  DOCUMENTS = [
    ReceiptNote,
    DeliveryNote
  ].freeze

  def create
    @document.post
    redirect_back fallback_location: root_path
  end

  def show
    @goods_entries = @document.goods_entries
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @document.undo_posting
    redirect_back fallback_location: root_path
  end

  private

    def find_document
      doc_type = DOCUMENTS.find { |d| params["#{d.to_s.underscore}_id"] }
      @document = doc_type.find(params["#{doc_type.to_s.underscore}_id"])
    end
end
