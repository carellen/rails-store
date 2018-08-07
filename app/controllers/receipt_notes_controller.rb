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

  def edit; end

  def update
    if @receipt_note.update(receipt_note_params)
      @receipt_note.undo_posting
      redirect_to @receipt_note
    else
      redirect_back fallback_location: root_path
    end
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
        incomes_attributes: [:item_id, :quantity, :price, :_destroy, :id])
    end
end
