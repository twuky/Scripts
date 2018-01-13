
class Sprite_LogoAnim < Sprite

  attr_accessor :anim_offset

  def initialize
    @base = 5
  end

  def update
    @rainbow_offset += 0.03
    self.color = Color.new(
        128 + Math.sin(@rainbow_offset) * 127,
        128 + Math.sin(@rainbow_offset + 2*Math::PI/3) * 127,
        128 + Math.sin(@rainbow_offset + 4*Math::PI/3) * 127, 255)
    @anim_offset += 0.2
    self.ox = Math.sin(@anim_offset) * 3 + @base
    self.oy = Math.cos(@anim_offset) * -3 + @base
    @base = @base * 0.999
  end

end

class tuckie_startup

  def Initialize
    @chars = ["t", "u", "c", "k", "i", "e"]
    @animchars = []
    @cur_width = 0
    @chars.each do |char|
      process_anim_character(char, @cur_width)
      16.times do
        Graphics.update
      end
    end

  end

  def process_anim_character(c, pos)
    text_width = text_size(c).width
    letter = Sprite_LogoAnim.new(self.viewport)
    letter.bitmap = Bitmap.new(text_width, Graphics.height / 2)
    letter.x = pos + Graphics.width / 4
    letter.y = Graphics.height / 2
    letter.z = 888
    letter.anim_offset = pos * 0.1
    letter.update
    bitmap.draw_text(0, 0, 10, pos[:height], c)
    @animchars.push(letter)
    pos += text_width * 3
    @cur_width = pos
  end

end
