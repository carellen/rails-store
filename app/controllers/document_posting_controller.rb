class DocumentPostingController < ApplicationController
  before_action :find_document, except: :index

  DOCUMENTS = [
    ReceiptNote,
    DeliveryNote
  ].freeze

  def index
    @goods_entries = GoodsEntry.all
  end

  def create
    DocumentService.new(@document).post
    redirect_back fallback_location: root_path
  end

  def show
    @goods_entries = @document.goods_entries
  end

  def destroy
    DocumentService.new(@document).delete
  end

  private

    def find_document
      doc_type = DOCUMENTS.find { |d| params["#{d.to_s.underscore}_id"] }
      @document = doc_type.find(params["#{doc_type.to_s.underscore}_id"])
    end
end
