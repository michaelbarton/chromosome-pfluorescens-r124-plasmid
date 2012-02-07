#!/usr/bin/env ruby
require 'csv'
require 'bio'

raw       = File.join(File.dirname(__FILE__),'gene_list.csv')
name_file = File.join(File.dirname(__FILE__),'names.yml')
output    = File.join(File.dirname(__FILE__),'..','assembly','annotations.gff')

names = YAML.load(File.read(name_file))

gffs = CSV.read(raw).map do |line|
  id, start, stop, strand, gc, _, _, product, _ = line
  name = names[id.to_i]

  attr = {'ID' => id, 'product' => product}
  attr['Name'] = name if name

  Bio::GFF::GFF3::Record.new('scaffold00008',nil,'gene',start,stop,nil,strand,nil,attr)
end

File.open(output,'w') do |out|
  out << "##gff-version 3\n"
  gffs.each do |gff|
    out << gff.to_s
  end
end
