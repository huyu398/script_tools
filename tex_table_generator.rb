require 'erb'
require 'pathname'
require 'csv'

CSV_FILE = Pathname(__FILE__) + '../test.csv'
TEMPLATE_FILE = Pathname(__FILE__) + '../table_template.tex.erb'
OUTPUT_FILE = Pathname(__FILE__) + '../table_output.tex'

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
