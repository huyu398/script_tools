require 'erb'
require 'pathname'
require 'csv'
require 'optparse'

OptionParser.new do |opt|
  opt.on('-c', '--caption=TITLE', 'Set the caption of the table') do |v|
    caption = v
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

caption ||= ''
dimensions = []
(0..columns).each do
  dimensions << 'c'
end
dimensions = '|' + dimensions * '|' + '|'

template= File.read(TEMPLATE_FILE)
File.write(OUTPUT_FILE, ERB.new(template, nil, '-').result(binding))
