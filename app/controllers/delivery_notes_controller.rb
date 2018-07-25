class DeliveryNotesController < ApplicationController
  def index
    @delivery_notes = DeliveryNote.all
  end

  def new
    @delivery_note = DeliveryNote.new
    @delivery_note.outcomes.build
  end

  def create
    @delivery_note = DeliveryNote.new(delivery_note_params)
    if @delivery_note.save
      redirect_to delivery_notes_path
    else
      render delivery_note_path
    end
  end

  private

    def delivery_note_params
      params.require(:delivery_note).permit(:customer, :date,
        outcomes_attributes: [:item_id, :quantity, :price, :_destroy])
    end
end
