# -*- encoding : utf-8 -*-

class BaseWrapper

  class << self
    def has_value?(value)
      value && !value.blank?
    end

    def has_size?(value)
      value && value.size > 0
    end

    def album_small_image(image_url)
      "#{image_url}!143X252" if image_url.present?
    end

    def tibet_image(image_url)
      "#{image_url}" if image_url.present?
    end

    def share_image(image_url)
      if image_url.present?
        "#{image_url}"
      else
        Util::DefaultSettings.app_share_logo
      end
    end

  end

end