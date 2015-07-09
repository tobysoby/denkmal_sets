require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
#coding: UTF-8

# page: Liste (Kulturdenkmäler in Berlin)
url = "https://de.wikipedia.org/wiki/Kategorie:Liste_(Kulturdenkm%C3%A4ler_in_Berlin)"

doc = Nokogiri::HTML(open(url))

bezeichnungen_array = Array.new
beschreibung_array = Array.new

#doc.css('li').css('a').each do |link|
doc.xpath('//a[starts-with(@title, "Liste der")]').each do |link|
    link_text = link.text
    if link_text.index('Liste d')
        link_2 = 'https://de.wikipedia.org' + link['href']
        bezirk_bezeichnung = link_text[28..link_text.length-1]
        bezirk = Nokogiri::HTML(open(link_2))
        bezirk.css('tr').each do |row|
            #puts row.css('td').size
            if (row.css('td').size == 5 || row.css('td').size == 4)
            #if row.text.index('Lage')
                CSV.open(bezirk_bezeichnung + '.csv', 'a+') do |csv|
                    begin
                        id = ""
                        lage = ""
                        bezeichnung = ""
                        beschreibung = ""
                        koordinaten_n = ""
                        koordinaten_e = ""
                        id = row.css('td')[0].text
                        id_link = row.css('td')[0].css('a')[0]['href']
                        lage = row.css('td')[1].text
                        puts lage
                        lage["(Lage)"] = ""
                        lage.chop.chop
                        #lage = row.css('td')[1].text
                        bezeichnung = row.css('td')[2].text
                        puts bezeichnung
                        beschreibung = row.css('td')[3].text
                        koordinaten = row.css('td')[1].css('a')[0]['href']
                        params = koordinaten.index('params')
                        koordinaten_n = koordinaten[params+7..params+15]
                        #koordinaten_n['_'] = ""
                        koordinaten_e = koordinaten[params+19..params+27]
                        if koordinaten_e[0] == "3"
                            koordinaten_e.insert(0, "1")
                        end
                        #koordinaten_e['_'] = ""
                        #koordinaten_e['E'] = ""
                        bild = ""
=begin
                        if row.css('td')[4].css('a')['href']
                            bild = row.css('td')[4].css('a')['href']
                            puts bild
                        end
=end
                        #puts id, lage, bezeichnung, beschreibung, koordinaten_n, koordinaten_e, bild
                    #csv << [row.css('td')[2].text, row.css('td')[1].text, row.css('td')[0].text, row.css('td')[0].css('a')[0]['href'], row.css('td')[3].text]
                        csv << [id, id_link, lage, bezeichnung, beschreibung, koordinaten_n, koordinaten_e, bild]
                    rescue
                        next
                    end
                end
            end
        end
    end
end