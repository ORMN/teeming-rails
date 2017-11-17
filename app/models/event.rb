class Event < ApplicationRecord
  has_many :event_rsvps
  belongs_to :chapter

  attr_accessor :occurs_at_date_str, :occurs_at_time_str

  scope :future, ->{ where(Event.arel_table[:occurs_at].gt(Time.zone.now)) }

  validates :name, presence: true

  validate :occurs_at_date_and_time_is_valid

  def set_accessors
    self.occurs_at_date_str = self.occurs_at.strftime("%m/%d/%Y")     if self.occurs_at
    self.occurs_at_time_str = self.occurs_at.strftime("%H:%M")        if self.occurs_at
  end

  def occurs_at_date_and_time_is_valid
    date = nil
    time = nil

    valid_date = validate_date(:occurs_at_date) { |d|
      date = d
    }
    valid_time = validate_time(:occurs_at_time) { |t|
      time = t
    }
    if valid_date && valid_time
      if date && !time
        self.occurs_at = Time.zone.local(date.year, date.month, date.day, 00, 00)
      elsif !date && time
        errors.add(:base, "must specify a date with a time")
      elsif date && time
        self.occurs_at = Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
      end
    end
  end
end