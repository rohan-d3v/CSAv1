class BonusCodesController < ApplicationController
  before_filter :check_is_registered, :only => [:claim, :claim_submit]
  def index
  end
end
