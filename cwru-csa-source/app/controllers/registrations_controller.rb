class RegistrationsController < ApplicationController
  before_filter :check_admin, :only => [:index, :destroy]
  before_filter :check_login, :only => [:new, :create, :show]
  before_filter :check_is_registered, :only => [:joinsquad]

  before_filter :require_can_register, only: [:new, :create]
  before_filter :require_personal_information, only: [:new, :create]
  before_filter :require_waiver, only: [:new, :create]

  def new
    @registration = Registration.where(person_id: @person, game_id: @current_game).first_or_initialize
    @squads = @current_game.squads.includes(:registrations)

    if @registration.card_code.present?
      return redirect_to registration_path(@registration)
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy if @registration

    redirect_to registrations_url
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy if @registration

    redirect_to registrations_url
  end

  def show
    @registration = Registration.find(params[:id])

    if @registration.person_id != @person.id
      flash[:error] = 'This is not your registration!!'
      return redirect_to root_url
    end
  end

  def update
    r = Registration.find(params[:id])

    if !@is_admin && r.person != @logged_in_person
      flash[:error] = "You do not have permission to edit this registration."
      redirect_to root_url()
    end

    r.attributes = params[:registration]
    r.save(validate: !@is_admin) # if admin, then don't validate.

    redirect_to edit_registration_url(params[:id])
  end

  def edit
    @registration = Registration.find(params[:id])
    @person = @registration.person

    if !@is_admin && @person != @logged_in_person
      flash[:error] = 'You do not have permission to edit this registration.'
      return redirect_to root_url
    end
  end


  def index
    @registrations = Registration.where(game_id: @current_game)
    @registrations.sort_by { |r| r.score } #todo: arel this
  end

  private

  def require_personal_information
    if @logged_in_person.name.blank?
      return redirect_to edit_person_url(@logged_in_person, next: 'registration')
    end
  end

end
