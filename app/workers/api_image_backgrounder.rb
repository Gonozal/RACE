class ApiImageBackgrounder
  @queue = :api_image_queue
  
  
  def self.perform(type, id, sizes = [32,64], delete = false)
    api = EVEAPI::API.new
    # new empty path variable...
    path = ""
    if delete
      api.delete_image(type, id)
    else
      sizes.each do |size|
        path = api.save_image(type, id, size)
        image = Magick::ImageList.new
        urlimage = open(path)
        image.from_blob(urlimage.read)
        save_path = api.image_path(type).join("#{id}_#{size}.jpg")
        image.save(save_path.to_s)
        if size == 128
          save_path = api.image_path(type).join("#{id}_48.jpg")
          image.resize_to_fit(48, 48)
          image.save(save_path.to_s)
        end
      end 
    end
  end
end
