require "spec_helper"

describe EasyBreadcrumbs do
  it "has a version number" do
    expect(EasyBreadcrumbs::VERSION).not_to be nil
  end

  it "correctly parses resource name and id" do
    request_path = "/contacts/28"
    breadcrumb = Breadcrumb.new(request_path)
    expect(false).to eq(true)
  end
end
