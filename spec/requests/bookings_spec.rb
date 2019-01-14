require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:room) {create(:room)}
  let!(:booking) {create(:booking, room_id: room.id)}
  let(:room_id) {room.id}

  describe 'POST /rooms/:room_id/bookings' do
    context 'when the request is valid' do
      before {post :create, {params: {room_id: room_id, start: '2001-02-03', end: '2001-04-03'}}}

      it 'creates a booking' do
        expect(response.body).to match(/Booking created/)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request contains colliding booking date with start date' do
      before {post :create, {params: {room_id: room_id, start: booking.start.prev_day, end: booking.start.next_day}}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Booking conflicts with an existing booking/)
      end
    end

    context 'when the request contains colliding booking date with end date' do
      before {post :create, {params: {room_id: room_id, start: booking.end.prev_day, end: booking.end.next_day}}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Booking conflicts with an existing booking/)
      end
    end

    context 'when the request contains colliding booking date - inside' do
      before {post :create, {params: {room_id: room_id, start: booking.start.next_day, end: booking.end.prev_day}}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Booking conflicts with an existing booking/)
      end
    end

    context 'when the request contains colliding booking date - outside' do
      before {post :create, {params: {room_id: room_id, start: booking.start.prev_day, end: booking.end.next_day}}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Booking conflicts with an existing booking/)
      end
    end

    context 'when the request is invalid' do
      before {post :create, {params: {room_id: room_id, start: 'foo'}}}

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Invalid arguments/)
      end

      it "when pass non existing room id" do
        post :create, params: {room_id: room_id + 100, start: '2002-02-03', end: '2002-04-03'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
