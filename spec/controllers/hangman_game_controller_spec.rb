require 'rails_helper'

RSpec.describe HangmanGameController do
  describe 'GET index' do
    it 'gets all games from the database' do
      create_list(:hangman_game, 5)
      expect(assigns(:games).length).to eql(5)
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
      create(:hangman_game)
      get :show, params: { :id => id }

      expect(response).to render_template("game")
    end
  end

  describe 'POST new' do
    before(:each) do
      post :new
    end

    it 'creates a new HangmanGame' do
      expect(assigns(:game)).to be_a_new(HangmanGame)
    end

    it 'renders the game template' do
      expect(response).to render_template("game")
    end
  end
end
