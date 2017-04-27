class RegistrationsController < ApplicationController
  before_filter :check_admin, :only => [:index, :destroy, :submit_waiver, :showwaiver, :find_by_code]
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

  def create
    @registration = Registration.
      where(person_id: @person, game_id: @current_game).
      first_or_initialize(params[:registration])
    @registration.score = 0
    @registration.squad = nil unless params[:squad_select] == "existing"

    @registration.human_type = 'Resistance'

    if !@registration.save
      flash[:error] = "Error, could not register you! #{@registration.errors.full_messages.first}"
      return redirect_to new_registration_url
    end

    if @registration.person.phone.present?
      Delayed::Job.enqueue SendNotification.new(@person,
        "Thank you for registering for this course.")
    end

    redirect_to registration_url(@registration)
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
    @squads = @current_game.squads.sort_by { |x| x.name } #todo: arel this
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
