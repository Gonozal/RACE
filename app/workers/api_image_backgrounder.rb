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
          Devil.with_image(path.to_s) do |img|
            save_path = api.image_path(type).join("#{id}_48.jpg")
            img.thumbnail2(48)
            img.save(save_path.to_s)
          end
        end
      end 
    end
  end
end