class GamesController < ApplicationController
  before_filter :check_admin, :only => [:new, :create, :edit, :update, :emails,
                                        :admin_register, :admin_register_create,
                                        :heatmap, :index, :update_current, :tools,
                                        :text, :text_create]

  def index
    @games = Game.includes(:registrations).order(:game_begins).all
  end

  def show
    @game = Game.where(id: params[:id]).first

    # Don't send new HTML if the content is cached on the client:
    return if !stale?(@game) && !Rails.env.development?

  end

  def rules
    @game = Game.find(params[:id]) || @current_game
  end

  def new
    @game = Game.new
  end

  def edit
    @game = Game.find(params[:id])
    unless params[:game].nil?
      @game = Game.new(params[:game])
    end
  end

  def create
    @game = Game.new(params[:game])
    if Game.current.id.nil?
      @game.is_current = true
    end

    if @game.save()
      redirect_to :action => :index
    else
      flash[:message] = @game.errors.full_messages.first
      redirect_to :action => :new
    end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to :action => :edit
    else
      flash[:error] = @game.errors.full_messages.first
      render :action => :edit
    end
  end

  def update_current
    @game = Game.find(params[:active_game])
    @game.set_current

    redirect_to games_url
  end

  def emails
    @game = Game.find(params[:id])
    @registrations = @game.registrations
    if params[:faction_id].present?
      @registrations = @registrations.where(faction_id: params[:faction_id])
    end

    if params[:human_type].present?
      @registrations = @registrations.where(human_type: params[:human_type])
    end
    @registrations = @registrations.includes(:person)
  end

  def admin_register_new
    @game = Game.find(params[:id])
    @squads = @game.squads
  end

  def admin_register_create
    @game = Game.find(params[:id])
    @person = Person.where(:caseid => params[:person][:caseid]).first_or_initialize
    if !@person.persisted?
      @person.update_attributes(:name => params[:person][:name], :phone => params[:person][:phone])
    end
    return redirect_to(admin_register_game_url(@game), :flash => { :error => 'You need to input a name for the person.' }) if !@person.name.present?
    return redirect_to(admin_register_game_url(@game), :flash => { :error => "Could not create or find person! #{@person.errors.full_messages.first}" }) if !@person.save

    if @registration.persisted?
      flash[:error] = 'User is already registered for this game!'
      redirect_to admin_register_game_url(@game)
    else
      @registration.card_code = Registration.make_code
      @registration.score = 0

      if @registration.save(:validate => false)
      else
        flash[:error] = 'Could not register due to an error!'
        redirect_to admin_register_game_url(@game)
      end
    end

  end

  def tools
  end
end
