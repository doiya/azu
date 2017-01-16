require 'net/http'
require 'uri'
require 'json'
require "rexml/document"

def reply_message(message='')
	message = {
    type: 'text',
    text: message
  }
end

# Csrousel
def reply_carousel_museums(museums)
  {
    "type": "template",
    "altText": "this is a carousel template",
    "template": {
        "type": "carousel",
        "columns": [
          hoge(museums[0]),
         	hoge(museums[1]),
         	hoge(museums[2]),
         	hoge(museums[3]),
         	hoge(museums[4])
        ]
    }
  }
end

def hoge(museum)
	puts museum["area"].size
	{
		"thumbnailImageUrl": "https://example.com/bot/images/item1.jpg",
    "title": museum["title"].slice(0,40-museum["area"].size-1) + '/' + museum["area"],
	  "text": museum["body"],
	  "actions": [
      {
        "type": "uri",
		    "label": "詳しく",
	  	  "uri": museum["url"]
      },
      {
        "type"; "postback",
        "label": "keep",
        "data": "keep"  #+ museum.to_s
      }
    ]
  }
end

def reply_museum_datas
	uri = URI.parse("http://www.tokyoartbeat.com/list/event_type_print_illustration.ja.xml")
	begin
	  response = Net::HTTP.start(uri.host) do |http|
	    http.get(uri.request_uri)
	  end
	  puts 'get response'
	  case response
	  when Net::HTTPSuccess
	  	doc = REXML::Document.new(response.body)
	  	array = []
	  	doc.elements.each('Events/Event') do |event|
	  	#doc.elements['Events'].each do |event|
		  	res = {}
		  	res["title"] = event.elements['Name'].text
		  	res["url"]   = event.attribute('href').to_s
		  	res["area"]  = event.elements['Venue/Area'].text
		  	res["body"]  = event.elements['Description'].text.gsub(/\n/, '').slice(0,59)
		  	array.push(res)
		 	end
		  puts array.count
	  	return array
	  when Net::HTTPRedirection
	  	puts 'warn'
	    logger.warn("Redirection: code=#{response.code} message=#{response.message}")
	  else
	  	puts 'error'
	    logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
	  end
	rescue IOError => e
		puts e.message
	rescue JSON::ParserError => e
		puts e.message
	rescue => e
		puts e.message
	end
end


# Buttons
def reply_buttons_museum(museum)
	{
	  "type": "template",
	  "altText": "this is a buttons template",
	  "template": {
	      "type": "buttons",
	      "thumbnailImageUrl": "https://example.com/bot/images/image.jpg",
	      "title": museum["title"] +  "\n" + museum["area"],
	      "text": museum["body"],
	      "actions": [
	          {
	            "type": "uri",
	            "label": "詳しく",
	            "uri": museum["url"]
	          },
            {
              "type": "postback",
              "label": "keep",
              "data": "keep" #+ museum.to_s
            }
	      ]
	  }
	}
end
=begin
def reply_template_museum(data)
	{
	  "type": "template",
	  "altText": "this is a buttons template",
	  "template": {
	      "type": "buttons",
	      "thumbnailImageUrl": "https://example.com/bot/images/image.jpg",
	      "title": data["title"] + "\n" + data["area"],
	      "text": data["body"],
	      "actions": [
	          {
	            "type": "uri",
	            "label": "詳しく",
	            "uri": data["url"]
	          },
            {
              "type": "postback",
              "label": "Keepする",
              "data": "keep, " + data.to_s
          },
	      ]
	  }
	}
end
=end

def reply_museum_data
	uri = URI.parse("http://www.tokyoartbeat.com/list/event_type_print_illustration.ja.xml")
	begin
	  response = Net::HTTP.start(uri.host) do |http|
	    http.get(uri.request_uri)
	  end
	  puts 'get response'
	  case response
	  when Net::HTTPSuccess
	  	doc = REXML::Document.new(response.body)
	  	#event = doc.elements['Events']
      puts 'move'
	  	res = {}
	  	res["title"] = event.elements['Event/Name'].text
	  	res["url"]   = event.elements['Event'].attribute('href').to_s
	  	res["area"]  = event.elements['Event/Venue/Area'].text
	  	res["body"]  =  event.elements['Event/Description'].text.slice(0,60)
	  	return res
	  when Net::HTTPRedirection
	  	puts 'warn'
	    logger.warn("Redirection: code=#{response.code} message=#{response.message}")
	  else
	  	puts 'error'
	    logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
	  end
	rescue IOError => e
		puts e.message
	rescue JSON::ParserError => e
		puts e.message
	rescue => e
		puts e.message
	end
end
