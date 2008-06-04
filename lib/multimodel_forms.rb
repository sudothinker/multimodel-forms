class << ActiveRecord::Base
  # has_many_with_attributes(:items, {:include => :user_id}, has_many args)
  def has_many_with_attributes(association_id, attr_options = {}, options = {}, &extension)
    # This is called when a form is submited.
    define_method "#{association_id}_attributes=" do |in_attributes|
      in_attributes.each_with_index do |attributes, j|
        if attributes[:id].blank?
          single = self.send("#{association_id}").build(attributes)
          unless attr_options[:include].blank?
            inc = attr_options[:include]
            inc = [inc] unless inc.instance_of?(Array)
            inc.each{ |i| self.send(association_id).each{ |x| x.send("#{i}=", self.send(i)) }}
          end
        else
          single = self.send("#{association_id}").detect { |e| e.id == attributes[:id].to_i }
          single.attributes = attributes
        end
        single.position = j+1 if single.has_attribute?(:position)
      end
    end
    
    class_eval "validates_associated :#{association_id}"
    # class methods
    class_eval "after_update :save_#{association_id}"    
    if options.empty?
      class_eval "has_many(:#{association_id})"
    else
      class_eval "has_many(:#{association_id}, #{options.inspect})"
    end
    
    # this will destroy/save the through relation models after self is updated
    define_method "save_#{association_id}" do
      self.send(association_id).each do |x|
        x.should_destroy? ? x.destroy : x.save(false)
      end
    end

    # Through methods
    through = association_id.to_s.classify.constantize
    through.class_eval "def should_destroy?; should_destroy.to_i == 1; end"
    through.class_eval "attr_accessor :should_destroy"
  end
  
  def belongs_to_with_attributes(association_name, attr_options = {}, options = {}, &extension)
    to_one_with_attributes("belongs_to", association_name, attr_options, options, &extension)
  end
  def has_one_with_attributes(association_name, attr_options = {}, options = {}, &extension)
    to_one_with_attributes("has_one", association_name, attr_options, options, &extension)
  end
  
  def to_one_with_attributes(to_name, association_name, attr_options = {}, options = {}, &extension)
    # This is called when a form is submited.
    define_method "#{association_name}_attributes=" do |in_params|
      in_params.delete(:id)
      if self.send("#{association_name}").nil?
        single = self.send("build_#{association_name}")
      else
        single = self.send("#{association_name}")
      end
      single.attributes = in_params
      puts attr_options.inspect
      unless attr_options[:push].blank?
        inc = attr_options[:push]
        inc = [inc] unless inc.instance_of?(Array)
        puts inc
        inc.each do |i|
          single.send("#{i}=", self.send(i))
        end
      end
    end
  
    through = association_name.to_s.singularize.camelize.constantize
  
    define_method "#{association_name}_attributes" do
      #self.send("build_#{association_name}") #RADAR don't do this results in current has-one association having it's fk set to null !!!
      through.new
    end
  
    # class methods
    class_eval "after_update :save_#{association_name}"    
    if options.empty?
      class_eval "#{to_name}(:#{association_name})"
    else
      class_eval "#{to_name}(:#{association_name}, #{options.inspect})"
    end
  
    # this will destroy/save the through relation models after self is updated
    define_method "save_#{association_name}" do
      x = self.send(association_name)
      return if x.nil? or x.frozen?
      if x.should_destroy?
        x.destroy
        self.send("#{association_name}=", nil)
      else
        x.save(false)
      end
    end
  
    # Through methods
    through.class_eval "def should_destroy?; should_destroy.to_i == 1; end"
    # always have a value to avoid holes in array params in forms
    through.class_eval "def should_destroy; @should_destroy ||= 0; end" 
    through.class_eval "attr_writer :should_destroy"
  end
end