require "spec_helper"
require "sinatra/base"

class Application < Sinatra::Base
  helpers Sinatra::EasyBreadcrumbs

  get "/" do
    easy_breadcrumbs
  end

  get "/categories/:category_id/edit" do
    easy_breadcrumbs
  end
end

describe Application do
  include Rack::Test::Methods

  def app
    Application.new
  end

  it "should be testable" do
    get "/"
    expect(last_response.status).to eq(200)
  end

  it "should add breadcrumb html to page" do
    get "/"
    expected_html = <<~HTML.chomp
      <ol class="breadcrumb">
        <li class="breadcrumb-item active">Home</li>
      </ol>
    HTML
    
    expect(last_response.body).to include(expected_html)
  end

  it "should only show breadcrumbs for routes that are defined" do
    get "/categories/5/edit"
    expected_html = <<~HTML.chomp
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="/">Home</a></li>
        <li class="breadcrumb-item active">Edit Category</li>
      </ol>
    HTML

    expect(last_response.body).to include(expected_html)
  end
end