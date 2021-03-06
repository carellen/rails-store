class DeliveryNotesController < ApplicationController
  include ReportService
  before_action :available_items, only: [:new, :create, :edit]
  before_action :find_delivery_note, only: [:new, :show, :edit, :update]

  def index
    @delivery_notes = DeliveryNote.all
  end

  def new; end

  def create
    @delivery_note = DeliveryNote.new(delivery_note_params)
    if @delivery_note.save
      redirect_to delivery_notes_path
    else
      render new_delivery_note_path
    end
  end

  def show
    @goods_entries = []
  end

  def update
    if @delivery_note.update(delivery_note_params)
      @delivery_note.undo_posting
      redirect_to @delivery_note
    else
      redirect_back fallback_location: root_path
    end
  end

  private

    def find_delivery_note
      if params[:id]
        @delivery_note = DeliveryNote.find(params[:id])
        @outcomes = @delivery_note.outcomes
      else
        @delivery_note = DeliveryNote.new
        @delivery_note.outcomes.build
      end
    end

    def delivery_note_params
      params.require(:delivery_note).permit(:customer, :date,
        outcomes_attributes: [:item_id, :quantity, :price, :_destroy, :id])
    end

    def available_items
      @items = ReportService.available_items.keys
    end
end
