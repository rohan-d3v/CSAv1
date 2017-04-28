class MissionsController < ApplicationController
  before_filter :check_admin, :except => [ :show, :index ]
  autocomplete :person, :name

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(params[:mission])
    @mission.game = @current_game
    if @mission.save
      redirect_to list_missions_path
    else
      flash[:error] = @mission.errors.full_messages.first
      redirect_to new_mission_path
    end
  end

  def index
    @missions = @current_game.missions.order(:start)
  end

  def show
    @mission = Mission.find(params[:id])
  end

  def list
    @missions = @current_game.missions.sort_by(&:start)
  end

  def edit
  @mission = Mission.find(params[:id])
  end

  def update
  @mission = Mission.find(params[:id])
  if @mission.update_attributes(params[:mission])
    redirect_to missions_url()
  else
    flash[:error] = "Could not save assignment"
    redirect_to root_url()
  end
  end

  def destroy
    @assignment = Mission.find(params[:id])
    @assignment.destroy if @assignment

    redirect_to missions_url
  end
end
