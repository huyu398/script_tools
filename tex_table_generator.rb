require 'erb'
require 'pathname'
require 'csv'
require 'optparse'

OptionParser.new do |opt|
  opt.parse!(ARGV)
end

CSV_FILE = Pathname.pwd + 'test.csv'
TEMPLATE_FILE = Pathname.pwd + 'table_template.tex.erb'
OUTPUT_FILE = Pathname.pwd + 'table_output.tex'

table = CSV.read(CSV_FILE)
columns = table.max_by { |e| e.size } .size
# nil fill
table.each do |row|
  row.fill(nil, row.size..columns-1)
end

caption = ''
dimensions = []
(0..columns).each do
  dimensions << 'c'
end
dimensions = '|' + dimensions * '|' + '|'

template= File.read(TEMPLATE_FILE)
File.write(OUTPUT_FILE, ERB.new(template, nil, '-').result(binding))
