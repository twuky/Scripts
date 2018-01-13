module Escape

  def self.scan_at(i, string)
    @result = Hash.new
    string = string.scan /\w/
    if string[i] == "/"
      output = ""
      c = 1
      until string[i + c] == " " do
        output += string[i + c]
        c += 1
      end
    else
      @result["result"] = false
      return result
    end
    self.seperate(output)
  end

  def self.seperate(output)
    output = output.scan /\w/
    name = ""
    val = ""
    bracket = false
    @result["result"] = true
    output.each do |char|
      bracket = true if char == "["
      name += char.upcase if !bracket
      val += char != "]" and bracket
    end
    @result["name"] = name
    @result["val"]  = val
    @result["num"]  = val.to_i
    return result
  end

end
