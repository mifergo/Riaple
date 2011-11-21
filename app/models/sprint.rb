class Sprint < ActiveRecord::Base
  validates_presence_of :start
  validates_presence_of :finish
  validates_presence_of :name
  validates_uniqueness_of :name

  validate :start_must_be_before
  validate :dates_must_not_collapse

  has_many :features

  attr_accessor :pendings
  attr_accessor :days
  attr_accessor :features
  attr_accessor :commercial_days
  attr_reader :theorics, :uppers, :lowers, :baseline



  def self.get_names()
     features = self.all
     my_names = []
     features.each do |fea|
       my_names << fea.name
     end
    return my_names
  end



  def self.is_commercial_day(date)
    if date.cwday() < 6
      return true
    end
    return false
  end

  def sprint_day(date)
    sprint_day = 0

    if date < start || date > finish
      return 0
    end
    if date == start
      return 1
    end

    (start..date).each do |day|
      if Sprint.is_commercial_day(day)
        sprint_day += 1
      end
    end

    return sprint_day

  end


  def self.selection
    Sprint.all(:order => :name).map{ |sp| [sp.name, sp.id] }.insert(0, ["TBD", nil])
  end

  def find_tasks_in_progress_by_feature(feature_id)
    tasks1 = []
    Track.find_all_by_sprint_id(id).each do |track|
      tasks1 << track.task
    end
    tasks2 = Task.find_all_by_feature_id(feature_id)
    return (tasks1 & tasks2)
  end

    def get_date_from_day(day)
    com_day = 0
    (start..finish).each do |d|

      if d.cwday <6
        com_day += 1
      end
      if com_day == day
        return d
      end
    end
  end

  def after_find
    calculate_commercial_days
  end

  def info_sprint
    calculate_pendings
    calculate_days
    find_features_in_progress
    calculate_theorics
    calculate_efforts
  end

  private

  def start_must_be_before
    unless (start.nil? || finish.nil?)
      errors.add(:start, "must be before finish") if start > finish
    end
  end

  def dates_must_not_collapse
    unless (start.nil? || finish.nil?)

      Sprint.all.each do |sp|
        if sp.id != id && (sp.start.between?(start, finish) || sp.finish.between?(start, finish))
          errors.add(:start, "date collapses with sprint #{sp.name}")
          errors.add(:finish, "date collapses with sprint #{sp.name}")

        end
      end
    end

  end


  def calculate_pendings
    @pendings = Array.new(@commercial_days, 0)

    Track.where(:sprint_id => id).each do |track|
      @pendings[track.day-1]+=track.pending
    end

  end

  def calculate_days
    @days = []
    (start .. finish).each do |day|
      if Sprint.is_commercial_day(day)
        @days << day.to_formatted_s(:short)
      end
    end

  end

  def calculate_commercial_days
    @commercial_days = 0
    for d in start..finish
      if d.cwday() <6
        @commercial_days+=1
      end
    end

  end



  def find_features_in_progress
    @features = []
    # first, search with tracks
    Track.find_all_by_sprint_id(id).each do |track|
      @features << Feature.find(Task.find(track.task_id).feature_id)
    end
    # finally, search all features marked in this sprint
    logger.debug "search features in sprint #{id}"
    @features.concat(Feature.find_all_by_sprint_id(id))
    # logger.debug @features
    @features.uniq!
  end

  def calculate_theorics
    @theorics = Array.new(@commercial_days, 0)
    per_day = @pendings[0].to_f/(@commercial_days.to_f-1)
    logger.debug ("calculate theoric per day #{per_day} = #{@pendings[0]} / #{@commercial_days-1}" )
    @theorics[0] = @pendings[0]
    (1..@commercial_days-1).each do |day|
      @theorics[day] =  @theorics[day-1] - per_day
    end
    # logger.debug "Theorics #{@theorics}"


    deviations = Array.new(@commercial_days, 0)
    (0..@commercial_days-2).each do |day|
      array = Array.new(@commercial_days-day){|t| theorics[day+t]}
      logger.debug array
      mean = array.inject {|x,y| x+y} / array.size
      sumOfSquares = array.map{ |x| (x-mean)**2 }.inject{|x,y| x+y }
      deviations[day] = Math.sqrt(sumOfSquares/(array.size-1))
    end
    deviations[@commercial_days-1] = theorics[@commercial_days-1]
    # logger.debug "Standard desviation #{@deviations}"

    @uppers = Array.new(@commercial_days, 0)
    @lowers = Array.new(@commercial_days, 0)
    (0..@commercial_days-1).each do |i|
      @uppers[i] = @theorics[i]+deviations[i]
      @lowers[i] = @theorics[i]-deviations[i]
    end
  end

  def calculate_efforts
    added = Array.new(@commercial_days, 0)
    dropped = Array.new(@commercial_days, 0)
    @baseline = Array.new(@commercial_days, 0)
    tracks = Array.new(@commercial_days, [] )

    (1..@commercial_days).each do |day|
      tracks[day-1] = Track.find_all_by_day_and_sprint_id(day, id)
    end
    tracks[0].each do |track_day|
      if track_day.task.start <= start
        added[0] += track_day.pending
      end
    end
    (1..@commercial_days-1).each do |i|
      tracks[i].each do |track_day|
        if sprint_day(track_day.task.start) == i+1
          added[i] += track_day.pending
        end
      end
    end

    # dropped  - theorically only tasks not started
    (0..@commercial_days-1).each do |i|
      tracks[i].each do |track_day|
        if track_day.task.state == LocalConfiguration::DROPPED
          dropped[i] += track_day.pending
        end
      end
    end

    (@commercial_days-1).downto(1) do |i|
      dropped[i] = dropped[i-1] - dropped[i]
    end

    # baseline
    @baseline[0] = added[0]
    (1..@commercial_days-1).each do |i|
      @baseline[i] = @baseline[i-1] + added[i] - dropped[i]
    end

  end


end
