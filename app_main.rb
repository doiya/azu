require 'sinatra'
require 'line/bot'
require './messages'
require './library'
get '/' do
  rand_genre[:url]
end

def client
	@client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] =~ /寝かせて/
          #client.reply_message(event['replyToken'], reply_message('少しお待ちください'))
          client.reply_message(event['replyToken'], reply_carousel_museums(reply_museum_datas))
        elsif event.message['text'] =~ /情報/
	        client.reply_message(event['replyToken'], reply_template_museum(reply_museum_data))
        else
	        client.reply_message(event['replyToken'], reply_message(event.message['text']))
  			end
      #when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
      #  response = client.get_message_content(event.message['id'])
      #  tf = Tempfile.open("content")
      #  tf.write(response.body)
      #end
    end
    # Postbackの場合
    when Line::Bot::Event::Postback
      if event["postback"]["data"] =~ /keep/
        client.reply_message(event['replyToken'], reply_message(event["postback"]["data"]))
      end
    end
  }

  "OK"
end
