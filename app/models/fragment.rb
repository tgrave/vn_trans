class Fragment < ApplicationRecord
  belongs_to :scenario

  before_destroy { |record| Line.where(fragment_id: record.id).each(&:destroy) }

  def line
    return unless translatable? && !location?
    return Line.find_by(fragment_id: id) if f_type == 16
    next_text = scenario.fragments.order(:order)
                        .where("`order` > ?", order).where(f_type: 16).first
    return if next_text.nil?
    next_text.line
  end

  def location
    return unless location?
    Location.find_by(fragment_id: id)
  end

  # Detects if fragments may be translated
  def translatable?
    [16, 24, 25].include? f_type
  end

  def location?
    f_type == 25
  end

  # Original text (for 16 and 24 types of objects)
  def orig_text
    orig_data[4..orig_data.size-1].tr("\x00", '')
  end

  # Translated text
  def translated_text
    return @translated_text unless @translated_text.nil?
    return unless translatable?
    l = location? ? location : line
    return if l.nil?
    @translated_text = case f_type
                       when 24
                         pad_with_limit l.new_who, 40
                       when 25
                         pad_with_limit l.new_content, 64
                       else
                         pad_string l.new_content
                       end
  end

  # Calculate new size for translated fragments
  def calc_size
    return size unless translatable?
    translated_text.size + 8
  end

  # Terminates and pads string with \0
  def pad_string(s)
    # s = s[0..80]
    b = s.bytes
    b << 0
    b << 0 while b.size % 4 > 0
    b.pack("c*")
  end

  # Pads talker tring with \0
  def pad_with_limit(s, limit)
    b = s[0..(limit - 2)].bytes
    b << 0 while b.size < limit
    b.pack("c*")
  end
end
