class BookingsController < ApplicationController
  def create
    room = Room.find(params[:room_id])

    if !room
      render json: {message: 'Invalid room id'}, status: :unprocessable_entity
    end

    if room.has_conflicting_bookings(params[:start], params[:end])
      render json: {message: 'Booking conflicts with an existing booking'}, status: :unprocessable_entity
    else
      if Booking.create(booking_params).valid?
        render json: {message: 'Booking created.'}, status: :ok
      else
        render json: {message: 'Invalid arguments.'}, status: :unprocessable_entity
      end
    end
  end

  private

  def booking_params
    params.permit(:start, :end, :room_id)
  end
end
