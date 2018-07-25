class ReceiptNotesController < ApplicationController
  def index
    @receipt_notes = ReceiptNote.all
  end

  def new
    @receipt_note = ReceiptNote.new
    @receipt_note.incomes.build
  end

  def create
    @receipt_note = ReceiptNote.new(receipt_note_params)
    if @receipt_note.save
      redirect_to receipt_notes_path
    else
      render new_receipt_note_path
    end
  end

  private

    def receipt_note_params
      params.require(:receipt_note).permit(:supplier, :date,
        incomes_attributes: [:item_id, :quantity, :price, :_destroy])
    end
end
