class Post < ActiveRecord::Base
  TITLE_STEP = "title"
  DESCRIPTION_STEP = "description"
  IMAGE_STEP = "image"

  STEPS = [TITLE_STEP, DESCRIPTION_STEP, IMAGE_STEP]

  attr_accessible :body, :title, :step, :image, :image_cache

  mount_uploader :image, ImageUploader

  validates :title, :presence => true, :if => :step_title?
  validates :body, :presence => true, :if => :step_description?

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

  private

  def step_title?
    self.step == TITLE_STEP
  end

  def step_description?
    self.step == DESCRIPTION_STEP
  end

  def step_image?
    self.step == IMAGE_STEP
  end

end
