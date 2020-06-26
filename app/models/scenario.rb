class Scenario < ApplicationRecord
  has_many :fragments

  # Import from the binary file
  def import
    fragments.each(&:destroy)
    File.open(bin_file_name, "rb") do |f|
      order = 0
      new_lines = 0
      until f.eof?
        new_lines += import_next_object(f, order)
        order += 1
      end
      update! lines: new_lines
    end
    add_locations
  end

  # Additionally import locations
  def add_locations
    new_locations = 0
    fragments.each do |f|
      next unless f.location?
      new_locations += add_location f
    end
    update! locations_count: Location.where(fragment: fragments).count
  end

  # Export to the binary file
  def export
    return if fragments.count.zero?
    File.open("#{bin_file_name}.new", "wb") do |f|
      i = 0;
      fragments.order(:order).each do |fr|
        i = export_object f, fr, i
      end
    end
  end

  # Completion color
  def completion_color
    return "ffffff" if translated.nil? || translated.zero? || lines.nil? || lines.zero?
    return "ff7777" if translated > lines
    return "#{ (255 - 128 * translated / lines).to_s(16) }ff77"
  end

  # Binary file name
  def bin_file_name(ext = 'in')
    Rails.root.join('data', "#{filename}.#{ext}")
  end

  # Import an object from the file
  def import_next_object(f, order)
    f_size = read_word(f)
    f_type = read_word(f)
    f_data = f.read(f_size - 4)
    frag = Fragment.create! order: order, orig_data: f_data, scenario_id: id, f_type: f_type, size: f_size
    f_type == 16 ? create_line(frag) : 0
  end

  # Create text fragment if text or person object is imported
  def create_line(frag)
    who = fragments.find_by order: frag.order - 1, f_type: 24
    Line.create! fragment_id: frag.id, who: (who.nil? ? nil : who.orig_text), content: frag.orig_text
    1
  end

  # Add a location for a fragment
  def add_location(f)
    return 0 if !f.location? || Location.exists?(fragment: f)
    Location.create! fragment_id: f.id, content: f.orig_text
    1
  end

  # Export next object to the file
  def export_object(f, fr, i)
    f.write pack_dword(fr.calc_size)
    f.write pack_dword(fr.f_type)
    if fr.translatable?
      # f.write pack_dword(fr.calc_size)
      # f.write pack_dword(fr.f_type)
      f.write fr.orig_data[0..3]
      f.write fr.translated_text
      i += 1
    else
      # f.write pack_dword(fr.size)
      # f.write pack_dword(fr.f_type)
      f.write fr.orig_data
    end
    i
  end

  # Read a word from the file
  def read_word(f)
    w = f.read(2).bytes
    (w[1] << 8) + w[0]
  end

  # Pack double word for export
  def pack_dword(w)
    [w & 255, w >> 8].pack("c*")
  end
end
