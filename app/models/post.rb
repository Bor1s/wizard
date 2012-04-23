class Post < ActiveRecord::Base

  #1. Add your custom steps here (remeber to create view partials with proper names: _step_title.html.erb, _step_image.html.erb etc.)
  TITLE_STEP = "title"
  DESCRIPTION_STEP = "description"
  IMAGE_STEP = "image"

  #2. Add your step to STEPS array (sequence is important)
  STEPS = [TITLE_STEP, DESCRIPTION_STEP, IMAGE_STEP]

  attr_accessible :body, :title, :step, :image, :image_cache

  mount_uploader :image, ImageUploader

  #3.Add validation for your fields and remember to set :if => lambda { |obj| obj.field_present?(YOUR_FIELD_SYMBOL) }
  #for proper validation on certain step.
  validates :title, :presence => true, :if => lambda { |obj| obj.field_present?(:title) }
  validates :body, :presence => true, :if => lambda { |obj| obj.field_present?(:body) }

  def step
    @step
  end

  def step=(value)
    if value.kind_of? Integer
      @step = value.to_i
    else
      @step = value
    end

    set_fields_for_validation
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

  protected

  def set_fields_for_validation
    #4. Add field symbols for certain steps to engage your validation
    self.fields_for_validation = [:title] if self.step == TITLE_STEP
    self.fields_for_validation = [:body] if self.step == DESCRIPTION_STEP
  end

  def field_present?(field_name)
    self.fields_for_validation.include? field_name
  end

  def fields_for_validation
    @fields_for_validation
  end

  def fields_for_validation=(values)
    @fields_for_validation = values.present? ? values : []
  end

end
