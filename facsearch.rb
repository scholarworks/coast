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
## puts row[1]

name = row[1]
name = row[3] + "," + name unless row[3] == nil

author_out = File.open(row[3] + "_" + row[1] + ".txt", "wb")

url = "http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=" + name + "&format=xerxes&max=100"

## @page = Nokogiri::XML(open("http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=Collier%2C+Aaron&format=xerxes&max=100"))


###############
### TEST QUERY
## http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=Lindholm,James&format=xerxes&max=100
###############

	dom = Nokogiri::XML(open(url))
	puts dom.class
	#puts dom
	
	nodeset = dom.xpath('//results/records/record/xerxes_record')
	puts nodeset.class
	## puts node
	
	nodeset.children.each do |element|
		## puts element.class
		## puts element.name
		authors_list = ""
		if element.name == 'authors'
			element.children.each do |node|
				puts node.class
				puts node.name
				author = ""
				node.children.each do |subnode|
					## puts subnode.class
					## puts subnode.name
					## if subnode.name == 'aufirst'
					## 	
					## end
					## if subnode.name == 'aulast'
					## end
					puts subnode['aufirst'].inner_text
				end
			end
		end   #test comment
	end
	
	## hash = node.element_children.each_with_object(Hash.new) do |e, h|
		## puts h[e.name.to_sym] + " => " + e.content
	## end

	## puts hash.inspect
## author_out << @page
## @xml_data = Nokogiri::XML.Reader(open("http://xerxes.calstate.edu/fullerton/articles/results?field=author&query=Collier%2C+Aaron&format=xerxes&max=100"))
## records = @page.xpath("//results//records[record[node()]]")
## puts records

### @page.each do |node|
###	headers = Array.new()
###	content = Array.new()
###	
###	if node.name == 'authors'
###		## puts "in authors node"
###		au_first = "";
###		au_last = "";
###		node.each do |auth_node|
###			if auth_node.name == "aufirst"
###				au_first = auth_node.inner_xml
###			end
###			if auth_node.name == "aulast">
###				au_last = auth_node.inner_xml
###			end
###		end
###		## puts au_last + ", " + au_first
##	end
	
##	if node.name == 'results'
##	node.elements.each do |element|
##				
##		if element.name == "xerxes_record"
##			##  puts "XERXES_RECORD"
##			element.elements.each do |sub_element|
##				## puts sub_element.name + " -- " + sub_element.inner_html
##				if sub_element.name == "authors"
##					sub_element.elements.each do |author|
##						puts " -- " + author
##					end
##				else
##
##					if @attributes.has_key? sub_element.name 
##						headers << sub_element.name if first_pass
##						content << sub_element.inner_html
##					end					
##				end
##			end
##		end 
##	end

##	csv_out << headers if first_pass
##	csv_out << content
		
	first_pass = FALSE
	## puts " -------------------------------- "

## end

end ## end of loop through CSV
