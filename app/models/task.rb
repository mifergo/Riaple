class Task < ActiveRecord::Base
  belongs_to :feature
  belongs_to :user
  has_many :tracks, :dependent => :destroy

  validate :valid_start
#  validates_presence_of :effort
  validates_numericality_of :effort

  # scope :located, ->(loc) {joins(:user).joins(:location).where('location.name = ?', loc)}

  def self.find_by_features(f_ids)
    Task.all :conditions => ["feature_id in (?)", f_ids], :order => "feature_id"
  end

  # get_last_start
  # return the most recently date between feature start date and start sprint date
  def get_last_start
    if (feature.start >= feature.sprint.start)
      feature.start
    else
      feature.sprint.start
    end
  end

#  def self.find_by_feature(f_id)
#    Task.all :conditions => ["feature_id in (?)", f_id], :order => "feature_id"
#  end

  def new_tracks

    tmp_day=1
    (@feature.sprint.start .. @feature.sprint.finish).each do |one_day|
       if Sprint.is_commercial_day(one_day)
         track = Track.new
         track.task_id=id
         track.sprint_id = feature.sprint.id
         track.day=tmp_day
         tmp_day=tmp_day+1
         if one_day<start
           track.pending=0
         else
           track.pending=effort
         end
         track.save
       end
    end
  end

  # this method controls if it is needed add track for this task, for example, when task is moved between sprints
  def update_tracks
    unless Track.find_by_sprint_id_and_task_id feature.sprint.id, id
      new_tracks
    end
  end

  def in_sprint?(sprint_id)
    Track.find_all_by_task_id(id).each do |track|
      if track.sprint_id == sprint_id
        return true
      end
    end
    return false
  end

  private

  def valid_start
    if ( start < feature.start )
      errors.add(:start, " must be the at same date or after the feature start date")
    end
  end

#  def in_sprint?(sprint)
#    return @tracks.find(sprint).nil? ? false : true
#  end

end

