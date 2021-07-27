require 'pp'

class UnitReader

  def initialize line
    m = line.match /(.+) (LI|LMI|HI|MI|WWg|LH|Art|Cv|HCh|Ct|Kn|El|SCh|HCh) \[?(\d)\]? (\d) (.+)/
    @name = m[1]
    @typ = m[2]
    @prot = m[3].to_i
    @co = m[4].to_i

    # p @name
    ext = @name.match /([^\*\(\)#1]+) ?(\*\*|\*|\#|\(1\))?/
    @name = ext[1].strip
    @ext = ext[2]
  end
end

File.open('data.txt', 'r').readlines.each do |line|
  r = UnitReader.new(line)
  pp r
end