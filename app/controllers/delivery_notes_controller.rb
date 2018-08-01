class DeliveryNotesController < ApplicationController
  include ReportService
  before_action :available_items, only: [:new, :create]

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
      render new_delivery_note_path
    end
  end

  def show
    @delivery_note = DeliveryNote.find(params[:id])
    @outcomes = @delivery_note.outcomes
  end

  def posting
    DocumentService.new(DeliveryNote.find(params[:id])).posting
    redirect_back fallback_location: delivery_notes_path
  end

  def undo
    DocumentService.new(DeliveryNote.find(params[:id])).delete
    redirect_back fallback_location: delivery_notes_path
  end

  private

    def delivery_note_params
      params.require(:delivery_note).permit(:customer, :date,
        outcomes_attributes: [:item_id, :quantity, :price, :_destroy])
    end

    def available_items
      @items = ReportService.available_items.keys
    end
end
