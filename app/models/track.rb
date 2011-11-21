class Track < ActiveRecord::Base
  belongs_to :task
  belongs_to :sprint

  validates_numericality_of :pending

  def update_pendings
    logger.debug "Track.update_pendings"
    if pending > task.effort
      task.effort = pending
    end
    if pending == 0
      task.state = LocalConfiguration::DONE
      task.finish = sprint.get_date_from_day(day)
    elsif !task.finish.nil?
      # update to pending
      task.state = LocalConfiguration::PENDING
      task.finish = nil
    end


    task.save
    task.feature.check_state



    Track.where("sprint_id = ? and task_id = ?", sprint.id, task.id ).each do |tu|
      logger.debug "day #{tu.day} from track #{tu.id} vs actual day #{day}"
      if tu.day > day
        tu.pending = pending
        tu.save
      end
    end
  end
end
