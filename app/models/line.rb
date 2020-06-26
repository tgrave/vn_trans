class Line < ApplicationRecord
  belongs_to :fragment
  belongs_to :user, foreign_key: :updated_by, required: false

  after_update :recalc_translated

  # Name or email of person who updated
  def updated_by_person
    return '' if updated_by.nil?
    user.username || user.email
  end

  # Is who may be translated
  def who_translatable?
    !(who.nil? || who.blank? || ['?', '%'].include?(who[0]))
  end

  # Returns either translated or original talker
  def new_who
    who_translatable? && who_translated.present? ? transcode(who_translated) : who
  end

  # Returns either translated or original text
  def new_content
    content_translated.present? ? transcode(content_translated) : content
  end

  # Change translation of Who for all lines of the scenario
  def change_all_who(translated_value)
    Line.where(fragment: fragment.scenario.fragments, who: who)
        .update_all(who_translated: translated_value)
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
      scenario.update! translated: Line.where(fragment: scenario.fragments)
                                       .where.not(content_translated: nil).count
    end
end
