require 'rails_helper'

RSpec.describe HangmanGameController do
  describe 'GET index' do
    it 'gets all games from the database' do
      create_list(:hangman_game, 5)

      get :index

      expect(assigns(:games))
      expect(:games.length).to eql(5)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe 'GET show(id)' do
    let(:id) { 10 }

    it 'gets the game specified by id' do
      create(:hangman_game, :id => id)
      get :show, params: { :id => id }

      expect(assigns(:game)[:id]).to eql(id)
    end

    it 'renders the game template' do
      game = create(:hangman_game)
      get :show, params: { id: game.id }

      expect(response).to render_template("game")
    end
  end

  describe 'POST new' do
    it 'creates a new HangmanGame' do
      expect { post :new }.to change(HangmanGame, :count).by(1)
    end

    it 'renders the game template' do
      post :new
      expect(response).to render_template("game")
    end
  end
end
