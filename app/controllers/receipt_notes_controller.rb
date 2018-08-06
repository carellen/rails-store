class ReceiptNotesController < ApplicationController
  before_action :find_receipt_note, only: [:new, :show, :edit, :update]
  def index
    @receipt_notes = ReceiptNote.all
  end

  def new; end

  def create
    @receipt_note = ReceiptNote.new(receipt_note_params)
    if @receipt_note.save
      redirect_back fallback_location: root_path
    else
      render new_receipt_note_path
    end
  end

  def show; end
  end

  private

    def find_receipt_note
      if params[:id]
        @receipt_note = ReceiptNote.find(params[:id])
        @incomes = @receipt_note.incomes
      else
        @receipt_note = ReceiptNote.new
        @receipt_note.incomes.build
      end
    end

    def receipt_note_params
      params.require(:receipt_note).permit(:supplier, :date,
        incomes_attributes: [:item_id, :quantity, :price, :_destroy])
    end
end
