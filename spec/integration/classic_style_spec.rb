require 'spec_helper'
require 'sinatra'

get "/" do
  easy_breadcrumbs
end

get "/categories/:id" do
  category = Struct.new(:name).new("Acquaintances")

  @category = category
  easy_breadcrumbs
end

get "/categories/:category_id/edit" do
  easy_breadcrumbs
end

describe Sinatra::Application do
  include Rack::Test::Methods

  def app
    Sinatra::Application
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
        <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
        <li class="breadcrumb-item active">Edit Category</li>
      </ol>
    HTML

    expect(last_response.body).to include(expected_html)
  end

  it "should show specific name of resource if instance variable is set" do
    get "/categories/5"
    expected_html = <<~HTML.chomp
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="/">Home</a></li>
        <li class="breadcrumb-item active">Acquaintances</li>
      </ol>
    HTML

    expect(last_response.body).to include(expected_html)
  end
end

