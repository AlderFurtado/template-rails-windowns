class MovesController < ApplicationController
  before_action :set_move, only: [:show, :update, :destroy]

  # GET /moves
  def index
    @moves = Move.all

    render json: @moves
  end

  # GET /moves/1
  def show
    render json: @move
  end

  # POST /moves
  def create
    @move = Move.new
    puts params
    @move.value = params[:value]

    if @move.save
      $kafka_producer.produce(@move.value, topic: "quickstart-events")
      $kafka_producer.deliver_messages
      # @products = Product.all
      render json: @move, status: :created, location: @move
    else
      render json: @move.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /moves/1
  def update
    if @move.update(move_params)
      render json: @move
    else
      render json: @move.errors, status: :unprocessable_entity
    end
  end

  # DELETE /moves/1
  def destroy
    @move.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_move
      @move = Move.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def move_params
      params.require(:move).permit(:value)
    end
end
