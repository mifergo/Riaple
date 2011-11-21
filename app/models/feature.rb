class Feature < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :project
  has_many :tasks, :dependent => :destroy

  validates_presence_of :project, :priority, :kind, :name

  validate :valid_start
  ACTIVITY = "Feature"
  BUG = "Bug"
  SUPPORT = "Support"
  TYPE = [ACTIVITY, BUG, SUPPORT]

  def sum_efforts
    @sum_efforts = 3
  end

  def in_sprint?(sprint_id)
    Task.find_all_by_feature_id(id).each do |task|
      if task.in_sprint?(sprint_id)
        return true
      end
    end
    return false
  end

  def update_tasks
    Task.find_all_by_feature_id_and_state(id, "Pending").each do |task|
      task.update_tracks
    end
  end

  def check_state
    all_done = true
    last_finish = 0
    logger.debug "feature::check_state with #{tasks.any?}"
    tasks.all.each do |t|
      if t.state != LocalConfiguration::DONE
        all_done = false
      else
        if (t.finish > last_finish)
          last_finish = t.finish
        end
      end
    end
    if all_done
      state = LocalConfiguration::DONE
      finish = last_finish
      save
    elsif state == LocalConfiguration::DONE
      state = LocalConfiguration::PENDING
      finish = nil
      save
    end
  end

  private

  def valid_start
    if (sprint!=nil && start>=sprint.finish)
      errors.add(:start, " must be before the sprint end date")
    end
  end

end
