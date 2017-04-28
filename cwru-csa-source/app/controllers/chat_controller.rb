class ChatController < ApplicationController
  before_filter :check_is_registered
  def index
  end
end
