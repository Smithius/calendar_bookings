require 'rails_helper'

RSpec.describe 'Booking API', type: :request do
  let!(:room) {create(:room)}
  let!(:booking) {create(:booking, room_id: room.id)}
  let(:room_id) {room.id}

  describe 'POST /rooms/:room_id/bookings' do
    let(:valid_attributes) {{start: '2001-02-03', end: '2001-04-03'}}

    context 'when the request is valid' do
      before {post "/rooms/#{room_id}/bookings", params: valid_attributes}

      it 'creates a booking' do
        expect(response.body).to match(/Booking created/)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request contains colliding booking dates' do
      before {post "/rooms/#{room_id}/bookings", params: {start: booking.start.prev_day, end: booking.start.next_month}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Booking conflicts with an existing booking/)
      end
    end

    context 'when the request is invalid' do
      before {post "/rooms/#{room_id}/bookings", params: {start: 'foo'}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Invalid arguments/)
      end
    end
  end
end