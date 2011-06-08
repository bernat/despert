module GravatarHelper

    # Return the HTML img tag for the given user's gravatar. Presumes that
    # the given user object will respond_to "email", and return the user's
    # email address.
    def gravatar_for(user, options={})
      raw gravatar(user.email, options)
    end

    # Return the HTML img tag for the given email address's gravatar.
    def gravatar(email, options={})
      src = h(gravatar_url(email, options))
      options = DEFAULT_GRAVATAR_OPTIONS.merge(options)
      [:class, :alt, :size, :title].each { |opt| options[opt] = h(options[opt]) }
      tabindex = (options.has_key?(:tabindex) ? "tabidex=#{options[:tabindex]}" : "")
      "<img class=\"#{options[:class]}\" title=\"#{options[:title]}\" alt=\"#{options[:alt]}\" width=\"#{options[:size]}\" height=\"#{options[:size]}\" src=\"#{src}\" #{tabindex} />"
    end

    # Returns the base Gravatar URL for the given email hash. If ssl evaluates to true,
    # a secure URL will be used instead. This is required when the gravatar is to be
    # displayed on a HTTPS site.
    def gravatar_api_url(hash, ssl=false)
      if ssl
        "https://secure.gravatar.com/avatar/#{hash}"
      else
        "http://www.gravatar.com/avatar/#{hash}"
      end
    end

    # Return the gravatar URL for the given email address.
    def gravatar_url(email, options={})
      email_hash = Digest::MD5.hexdigest(email)
      options = DEFAULT_GRAVATAR_OPTIONS.merge(options)
      options[:default] = CGI::escape(options[:default]) unless options[:default].nil?
      gravatar_api_url(email_hash, options.delete(:ssl)).tap do |url|
        opts = []
        [:rating, :size, :default].each do |opt|
          unless options[opt].nil?
            value = h(options[opt])
            opts << [opt, value].join('=')
          end
        end
        url << "?#{opts.join('&')}" unless opts.empty?
    end
  end
end
