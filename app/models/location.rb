class Location < ApplicationRecord
  belongs_to :fragment
  belongs_to :user, foreign_key: :updated_by, required: false

  after_update :recalc_translated

  # Name or email of person who updated
  def updated_by_person
    return '' if updated_by.nil?
    user.username || user.email
  end

  # Returns either translated or original text
  def new_content
    content_translated.present? ? transcode(content_translated) : content
  end

  # Transcode string
  def transcode(s)
    s.split('').reduce("") { |a, c| a + (trans_table[c].nil? ? c : trans_table[c]) }
  end

  # Returns transcoding table
  def trans_table
    @trans_table ||= File.readlines(Rails.root.join("data", "transcode.txt"))
                         .collect { |e| e.strip.split(' ') }.to_h
  end

  private

    def recalc_translated
      scenario = fragment.scenario
      scenario.update! locations_translated: Location.where(fragment: scenario.fragments)
                                                     .where.not(content_translated: nil).count
    end
end
