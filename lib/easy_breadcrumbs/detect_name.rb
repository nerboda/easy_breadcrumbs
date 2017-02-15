module EasyBreadcrumbs
  module DetectName
    COMMON_NAME_ATTRIBUTES = %i[name title subject]

    def detect_name(resource)
      name_attribute = find_common_name_attribute(resource)
      resource[name_attribute] if name_attribute
    end

    private

    def find_common_name_attribute(resource)
      COMMON_NAME_ATTRIBUTES.find do |method|
        resource.respond_to?(method) || resource.key?(method)
      end
    end
  end
end
