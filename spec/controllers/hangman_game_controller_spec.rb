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
    let(:guess_service) { instance_double(MakeGuess) }
    before do
      allow(MakeGuess).to receive(:new).and_return guess_service
      allow(guess_service).to receive(:error_messages)
      allow(guess_service).to receive(:call)
    end

    it 'calls the MakeGuess service\'s call method' do
      expect(guess_service).to receive(:call)

      put :update, params: { :id => game.id, :guess => 'f' }
    end
  end
end
