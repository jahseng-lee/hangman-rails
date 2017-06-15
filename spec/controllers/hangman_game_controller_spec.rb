require 'rails_helper'

RSpec.describe HangmanGameController do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe 'GET show(id)' do
    let(:game) { create(:hangman_game) }

    it 'gets the game specified by id' do
      get :show, params: { id:  game.id }

      expect(assigns(:game)).to eql(game)
    end

    it 'renders the show template' do
      get :show, params: { id: game.id }

      expect(response).to render_template('show')
    end
  end

  describe 'POST create' do
    it 'creates a new HangmanGame' do
      expect { post :create }.to change(HangmanGame, :count).by(1)
    end

    it 'renders the show template' do
      post :create
      expect(response).to redirect_to HangmanGame.last
    end
  end

  describe 'PUT update' do
    let(:game) { create(:hangman_game) }
    let(:update_request) { put :update, params: { :id => game.id, :guess => 'f' } }

    it 'calls the MakeGuess service' do
      expect_any_instance_of(MakeGuess).to receive(:call)

      update_request
    end

    context 'given MakeGuess returns a truthy value' do
      let(:make_guess_service) { instance_double("MakeGuess", :call => true) }
      it 'renders the show template' do
        update_request

        expect(response).to redirect_to HangmanGame.last
      end
    end
  end
end
