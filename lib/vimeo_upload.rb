require "vimeo_upload/version"
require "httparty"

module VimeoUpload

  # Upload function
  def self.upload(filepath, filename, api_key)

    # Upload a video to vimeo
    # I prefer putting api_key as an environment variable. Use figaro gem if needed
    # Call function in the following format
    # VimeoUpload.upload(absolute_filepath, filename, vimeo_key)
    # eg;
    # VimeoUpload.upload("#{Rails.root}/public/uploads/video.webm", 'My Video', ENV['api_key'])
    # Return a video_id that references to the video

    auth = "bearer #{api_key}"

    # create ticket
    resp = HTTParty.post "https://api.vimeo.com/me/videos", 
                          headers: {"Authorization" => auth, 
                                    "Accept" => "application/vnd.vimeo.*+json;version=3.2"}, 
                          body: {type: "streaming"}

    ticket = JSON.parse(resp.body)
    if resp.body['error']
      raise StandardError, ticket['error']
    end
    target = ticket["upload_link_secure"]
    size = File.size(filepath)
    last_byte = 0
    # create ticket end

    # upload video
    File.open(filepath, "rb") do |f|
      uri = URI(target)
      while last_byte < size do
        req = Net::HTTP::Put.new("#{uri.path}?#{uri.query}", initheader = {"Authorization" => auth, "Content-Type" => "video/mp4", "Content-Length" => size.to_s})
        req.body = f.read

        begin
          http=Net::HTTP.new(uri.host, uri.port)
          http.use_ssl=true
          response = http.request(req)

        rescue Errno::EPIPE
          puts "Error occured"
        end

        progress_resp = HTTParty.put target, headers: {"Content-Range" => 'bytes */*', "Authorization" => auth}
        last_byte = progress_resp.headers["range"].split("-").last.to_i
      end
    end
    # upload video end

    # delete ticket (required to view video in vimeo)
    complete_uri=ticket["complete_uri"]

    uri = URI("https://api.vimeo.com" + complete_uri)
    delete_req = Net::HTTP::Delete.new("#{uri.path}?#{uri.query}", initheader = {"Authorization" => auth})

    begin
      http=Net::HTTP.new(uri.host, uri.port)
      http.use_ssl=true
      delete_resp = http.request(delete_req)

    rescue Errno::EPIPE
      puts "Error occured"
    end

    video_location = delete_resp["location"]
    # delete ticket end

    video_id = video_location.split('/')[2]
    
    # change title
    change_title(filename, video_id, api_key)

    return video_id
  end
  

  # Change video title
  def self.change_title(filename, video_id, api_key)

    # Change video title of a video in vimeo
    # I prefer putting api_key as an environment variable. Use figaro gem if needed
    # Call function in the following format
    # VimeoUpload.change_title(filename, video_id, vimeo_key)
    # eg;
    # VimeoUpload.upload("'My Video', '123456789', ENV['api_key'])
    # Returns the video_id

    auth = "bearer #{api_key}"

    uri = URI("https://api.vimeo.com/videos/#{video_id}")

    patch_req = Net::HTTP::Patch.new("#{uri.path}?#{uri.query}", initheader = {"Authorization" => auth, "name" => "Test"})
    patch_req.set_form_data({"name" => filename})


    begin
      http=Net::HTTP.new(uri.host, uri.port)
      http.use_ssl=true
      patch_resp = http.request(patch_req)

    rescue Errno::EPIPE
      puts "Error occured"
    end
    
    return video_id
  end

end
