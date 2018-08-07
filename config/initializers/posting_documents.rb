# Enable document posting in models.
ActiveSupport.on_load(:active_record) do
  extend Postable::ClassMethods
end
