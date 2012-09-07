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
        if size == 128
          img = Magick::Image::read(api.image_path(type) + path).first
          thumb = img.resize_to_fill(48, 48)
          save_path = (api.image_path(type) + path).sub(/_128\.jpg/, "_48.jpg")
          thumb.write(save_path)
        end
      end 
    end
  end
end
