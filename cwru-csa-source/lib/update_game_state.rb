#TODO: This file should contain the logic to, at any point,
# determine based on the database state, precisely who is
# human, zombie, and deceased. This script should also calculate
# point totals.
#
# Note: This file is responsible for being the correct
# judge of the current state. This file should update the following
# 'caches' of the current state -- so it can be easily
# accessed elsewhere:
#   registration.faction_id
#   registration.score
#
# Also, this file should store the current game state in the database
# if it has changed -- so all changes can be tracked over time.
class UpdateGameState
  FORUMS_URI = 'INSERT FORUM LINK'

  def initialize
    @current_game = Game.current
  end

  def perform
    Time.zone = @current_game.time_zone

    @players = @current_game.registrations.includes(:person)

    @deceased_faction = @players.select(&:is_deceased?)

    @players.each {|x| x.score = 0} # Reset the scores
    calculate_mission_scores(@players)
    calculate_human_scores(@players)
    calculate_zombie_tag_scores(@zombie_faction)
    calculate_cache_scores(@players)


    update_faction_cache(factions)
    update_forums(factions)

    # We have to override validation because the registrations are generally not changable
    # acollectfter registration ends.
    changed = false
 
    @current_game.touch if changed
    Delayed::Job.enqueue(UpdateGameState.new(),{ :run_at => Time.now + 1.minute })
  end

  def update_forums(factions)
    return unless forums_reachable?

 
    params = {}
    params[:core] = Person.where(is_admin: true).pluck(:caseid).join(',')

    uri = URI.parse(FORUMS_URI)
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params.merge(api_key: 'fa7eb9f91ac0dee653d991f9b44f72f8f05421a157b00369162aa978d30d56a4'))

    http.request(request)
  end

  def forums_reachable?
    begin
      uri = URI.parse(FORUMS_URI)
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    rescue Errno::ECONNRESET => e
      Rails.logger.error "Failed to update forums. Exception message: #{e.message}"
      false
    else
      true
    end
  end

  def update_faction_cache(factions)
    factions[:human].each do |h|
      h.faction_id = 0
    end
end
