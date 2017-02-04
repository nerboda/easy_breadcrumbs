module EasyBreadcrumbs
  module AutoDetect
    COMMON_NAME_ATTRIBUTES = %i[name title subject]

    def detect_name(resource)
      name_attribute = find_common_accessor_method(resource)
      return resource[name_attribute] if name_attribute

      name_attribute = find_common_hash_symbol(resource)
      return resource[name_attribute] if name_attribute
    end

    private

    def find_common_accessor_method(resource)
      COMMON_NAME_ATTRIBUTES.find do |method|
        resource.respond_to?(method)
      end
    end

    def find_common_hash_symbol(resource)
      COMMON_NAME_ATTRIBUTES.find do |method|
        resource.key?(method)
      end
    end
  end
end
