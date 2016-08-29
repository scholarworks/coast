require 'nokogiri'
require 'open-uri'
require 'csv'

@attributes = {
	"title" => "TITLE",
	"year" => "YEAR",
	"month" => "MONTH",
	"journal_title" => "JOURNAL",
	"journal" => "CITATION",
	"volume" => "VOLUME",
	"issue" => "ISSUE",
	"summary" => "SUMMARY",
	"primary_author" => "AUTHOR"
}

csv_out = CSV.open("/tmp/export.csv", "wb")   # open the output file

## loop over the input file.
first_pass = TRUE

CSV.foreach("coast.csv", :headers=>false) do |row|
puts row[1]

name = row[1]
name = row[3] + "," + name unless row[3] == nil

author_out = File.open(row[3] + "_" + row[1] + ".txt", "wb")

url = "http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=" + name + "&format=xerxes&max=100"

## @page = Nokogiri::XML(open("http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=Collier%2C+Aaron&format=xerxes&max=100"))
@page = Nokogiri::XML(open(url))
author_out << @page

## @xml_data = Nokogiri::XML.Reader(open("http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=Collier%2C+Aaron&format=xerxes&max=100"))

records = @page.xpath("//results//records[record[node()]]")

## puts records


records.children.each do |node|
	headers = Array.new()
	content = Array.new()
	
	## puts " -------------------------------- "
	## puts node.children.size
	node.elements.each do |element|
				
		if element.name == "xerxes_record"
			##  puts "XERXES_RECORD"
			element.elements.each do |sub_element|
				## puts sub_element.name + " -- " + sub_element.inner_html
				if sub_element.name == "authors"
					sub_element.elements.each do |author|
						puts " -- " + author
					end
				else

					if @attributes.has_key? sub_element.name 
						headers << sub_element.name if first_pass
						content << sub_element.inner_html
					end					
				end
			end
		end 
	end

	csv_out << headers if first_pass
	csv_out << content
		
	first_pass = FALSE
	## puts " -------------------------------- "

end

end ## end of loop through CSV

## records.each do |node|
## 	puts node
## end

##@xml_data.each do |node|
## 	puts node.name
##	puts node.keys
##	put node.values
####	if node.name == "records"
####		node.children.each do |record_node|
####			puts record_node.name
####		end
####	end
##end

## records_node = @xml_data.at("//results//records")
## puts records_node.children.count

# @page.xpath("//results//records//record").each do |record|



##
##for record in records
##	# puts record
##	@xrecord = Nokogiri::XML(record.to_s)
##	# puts @xrecord
###
### journal = @xrecord.xpath("//xerxes_record//journal_title")
###
###puts journal.name + " => " + journal.text
##
##	journal = @xrecord.xpath("//xerxes_record//journal_title")
##	authors = @xrecord.xpath("//xerxes_record//authors")
##	numbers = @xrecord.xpath("//xerxes_record//standard_numbers")
##	title = @xrecord.xpath("//xerxes_record//title")
##	year = @xrecord.xpath("//xerxes_record//year")
##	abstract = @xrecord.xpath("//xerxes_record//abstract")
##	subjects = @xrecord.xpath("//xerxes_record//subjects")
##	
##	puts title.text + "," + year.text + "," + journal.text + "," + abstract.text
##	# if journal
##	# puts journal.text
##	# end
##end
##