module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      target = @attachment.instance
      if target.cropping?
        target.cropped = true
        original_geo = target.image_geometry(:original)
        if original_geo.width > original_geo.height
          ratio = original_geo.height / 450
        else
          ratio = original_geo.width / 450
        end
        super.unshift(" -crop #{(target.crop_w.to_i * ratio).round}x#{(target.crop_h.to_i * ratio).round}+#{(target.crop_x.to_i * ratio).round}+#{(target.crop_y.to_i * ratio).round}")
      else
        super
      end
    end
  end
end