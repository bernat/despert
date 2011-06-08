class Date                    # reopen Date class
  def to_yaml( opts={} )      # modeled after yaml/rubytypes.rb in std library
    YAML::quick_emit( self, opts ) do |out|
      out.scalar( "tag:yaml.org,2002:timestamp", self.to_s(:db), :plain )
    end
  end
end
