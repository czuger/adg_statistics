require 'pp'
require 'json'
require 'yaml'

class UnitReader

  attr_reader :typ, :name

  CONVERSION = {
    'tous' => %w(LI LMI HI MI WWg LH Art Cv HCh Ct Kn El SCh HCh),
    'piétions' => %w(LI LMI HI MI),
    'montés' => %w(LH Cv Ct Kn El)
  }

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

    @bonuses = {}
    read_bonuses m[5]
  end

  def to_j
    {
      'name': @name, 'typ': @typ, 'prot': @prot, 'co': @co, 'ext': @ext
    }
  end

  private
  def read_bonuses(string)
    p string
    result = string.scan( /\+?(\d) (au 1er tour )?vs ([^+]+)/ )
    result.each do |e|
      p e[0]
      p e[2]
      e[2].scan( /(tous|montés|piétons|LI|LMI|MI|HI|Cv|LH|El|SCh|Ct|HCh|Kn)/ ).each do |vs_type|
        vs_type = vs_type.first
        if CONVERSION[vs_type]
          CONVERSION[vs_type].each do |typ|
            @bonuses[typ] = e[0].to_i
          end
        else
          @bonuses[vs_type] = e[0].to_i
        end
      end
    end
    puts
  end
end

pp UnitReader::CONVERSION

units = {}

File.open('data.txt', 'r').readlines.each do |line|
  r = UnitReader.new(line)
  units[r.typ] = r
end

File.open('data.yaml', 'w') do |f|
  f.write(units.to_yaml)
end

# pp units

# def stats(a, d)
#   1.upto(1000) do
#     tmp_a = a.dup()
#     tmp_d = d.dup()
#
#   end
# end
#
# units.each_value do |a|
#   units.each_value do |d|
#     if a.name != d.name
#       puts "#{a.name} vs #{d.name}"
#     end
#   end
# end