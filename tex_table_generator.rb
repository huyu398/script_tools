require 'erb'
require 'pathname'
require 'csv'
require 'optparse'

option = Hash.new
OptionParser.new do |opt|
  opt.on('-c', '--caption=TITLE', 'Set the caption of the table (default caption is basename of target file).') do |v|
    option[:caption] = v
  end
  opt.on('-d', '--docmute', 'Use docmute package in output file.') do |v|
    option[:docmute] = v
  end
  opt.on('-f', '--frame=PATTERN', /(l?)([tT]?)([bB]?)(r?)/,
         "Set the pattern of table's frame border (it's not grid lines).",
         "You can set left, top, bottom and right frame, and bold frame only top and bottom",
         "ex) --frame=ltbr : with left, top, bottom, and right frame",
         "    --frame=TB   : with top and bottom bold frame",
         "    --frame=rT   : this setting order is invalid",
         "    --frame=Tr   : this setting order is valid"
        ) do |v|
    # mapping table from character to word
    mapping = {
      l: :left,
      t: :top,
      T: :top_bold,
      b: :bottom,
      B: :bottom_bold,
      r: :right
    }
    # remove unnecessary elements
    v.shift
    v.delete('')

    frame = {}
    v.each do |p|
      frame[mapping[p.to_sym]] = true
    end
    option[:frame] = frame
  end
  opt.parse!(ARGV)
end

exit 1 unless ARGV.size == 1

CSV_FILE = Pathname.new(ARGV[0]).expand_path
TEMPLATE_FILE = Pathname.pwd + 'table_template.tex.erb'
OUTPUT_FILE = Pathname.pwd + 'table_output.tex'

# input file check
unless CSV_FILE.exist?
  STDERR.puts "missing #{CSV_FILE}"
  exit 1
end
unless CSV_FILE.file?
  STDERR.puts "#{CSV_FILE} is a directory"
  exit 1
end

table = CSV.read(CSV_FILE)
columns = table.max_by { |e| e.size } .size
# nil fill
table.each do |row|
  row.fill(nil, row.size..columns-1)
end

caption = option[:caption] || File.basename(CSV_FILE, File.extname(CSV_FILE))
dimensions = 'c|' * (columns - 1) + 'c'
if option[:frame]
  dimensions =  '|' + dimensions if option[:frame][:left]
  dimensions =  dimensions + '|' if option[:frame][:right]
end

template= File.read(TEMPLATE_FILE)
File.write(OUTPUT_FILE, ERB.new(template, nil, '-').result(binding))
