class Post < ActiveRecord::Base
  attr_accessible :body, :title, :step

  STEPS = [1, 2]

  validates :title, :presence => true, :if => lambda { |p| p.step >= STEPS.first }
  validates :body, :presence => true, :if => lambda { |p| p.step >= STEPS.second }

  def step
    @step
  end

  def step=(value)
    if value.kind_of? Integer
      @step = value.to_i
    else
      @step = value
    end
  end

  def all_valid?
    STEPS.all? do |s|
      self.step = s
      self.valid?
    end
  end

  def next_step
    self.step = STEPS[STEPS.index(self.step) + 1]
  end

  def prev_step
    self.step = STEPS[STEPS.index(self.step) - 1]
  end

  def first_step?
    self.step == STEPS.first
  end

  def last_step?
    self.step == STEPS.last
  end
end
