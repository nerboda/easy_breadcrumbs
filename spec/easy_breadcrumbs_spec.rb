require "spec_helper"

describe EasyBreadcrumbs do
  it "has a version number" do
    expect(EasyBreadcrumbs::VERSION).not_to be nil
  end

  describe Breadcrumb do
    it "requires a request_path argument on instantiation" do
      expect { Breadcrumb.new }.to raise_error(ArgumentError)
    end

    describe "#to_html" do
      it "returns proper html for simple path" do
        request_path = "/about"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item active">About</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to resource index page" do
        request_path = "/contacts"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item active">Contacts</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to specific resource" do
        request_path = "/contacts/28"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
          <li class="breadcrumb-item active">Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to resource new view" do
        request_path = "/contacts/new"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
          <li class="breadcrumb-item active">New</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to edit specific resource" do
        request_path = "/contacts/28/edit"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
          <li class="breadcrumb-item"><a href="/contacts/28">Contact</a></li>
          <li class="breadcrumb-item active">Edit</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to nested resource index page" do
        request_path = "/categories/5/contacts"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
          <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
          <li class="breadcrumb-item active">Contacts</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to specific nested resource" do
        request_path = "/categories/5/contacts/10"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
          <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
          <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
          <li class="breadcrumb-item active">Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to nested resource new view" do
        request_path = "/categories/5/contacts/new"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
          <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
          <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
          <li class="breadcrumb-item active">New</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to edit specific nested resource" do
        request_path = "/categories/5/contacts/10/edit"
        breadcrumb_html = Breadcrumb.new(request_path).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="/">Home</a></li>
          <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
          <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
          <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
          <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Contact</a></li>
          <li class="breadcrumb-item active">Edit</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      # it "returns proper html for path to edit specific nested resource with all index pages turned off" do
      #   request_path = "/categories/5/contacts/10/edit"
      #   breadcrumb_html = Breadcrumb.new(request_path).to_html
      #   expected_html = <<~HTML.chomp
        
      #   HTML
      #   expect(breadcrumb_html).to eq(expected_html)
      # end

      # it "returns proper html for path to edit specific nested resource with specific index pages turned off" do
      #   request_path = "/categories/5/contacts/10/edit"
      #   breadcrumb_html = Breadcrumb.new(request_path).to_html
      #   expected_html = <<~HTML.chomp
        
      #   HTML
      #   expect(breadcrumb_html).to eq(expected_html)
      # end
    end
  end
end
