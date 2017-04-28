class IndexController < ApplicationController
  def root
    @players = @current_game.registrations
    @ozs = @current_game.ozs
  end
end
