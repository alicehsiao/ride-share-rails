class TripsController < ApplicationController
  before_action :get_trip, only: [:show, :edit, :update, :destroy]

  def show; end

  def create
    if params[:passenger_id]
      @trip = Trip.request_trip(params[:passenger_id].to_i)

      if @trip == nil
        redirect_to root_path
      else
        @trip.save
        redirect_to passenger_path(params[:passenger_id])
      end
    end
  end

  def edit; end

  def update
    @trip.end_trip(trip_params[:rating])

    if @trip.update(rating: trip_params[:rating], cost: @trip.cost, in_progress: @trip.in_progress)
      redirect_to trip_path
    else
      render :edit
    end
  end

  def destroy
    if !@trip.nil?
      @trip.active = false

      if @trip.save
        redirect_to root_path
      end
    end
  end

  private
  def trip_params
    return params.require(:trip).permit(:driver_id, :passenger_id, :rating, :in_progress, :active, :cost)
  end

  def get_trip
    @trip = Trip.find_by(id: params[:id].to_i)

    if @trip.nil?
      render :notfound, status: :not_found
    end
  end
end
