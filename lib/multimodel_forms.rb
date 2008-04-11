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
    through = association_id.to_s.singularize.capitalize.constantize
    through.class_eval "def should_destroy?; should_destroy.to_i == 1; end"
    through.class_eval "attr_accessor :should_destroy"
  end
end