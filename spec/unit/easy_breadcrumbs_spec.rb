require "spec_helper"

describe EasyBreadcrumbs do
  it "has a version number" do
    expect(EasyBreadcrumbs::VERSION).not_to be nil
  end

  Breadcrumbs = EasyBreadcrumbs::Breadcrumbs

  describe Breadcrumbs do
    it "requires an `options` argument on instantiation" do
      expect { Breadcrumbs.new }.to raise_error(ArgumentError)
    end

    def configure(path, routes = nil, view_variables = [])
      routes ||= [ /\A\/\z/,
                   /\A\/contacts\/new\z/,
                   /\A\/contacts\/([^\/?#]+)\z/,
                   /\A\/contacts\/([^\/?#]+)\/edit\z/,
                   /\A\/categories\/new\z/,
                   /\A\/categories\/([^\/?#]+)\z/,
                   /\A\/about\z/, /\A\/contacts\z/,
                   /\A\/categories\z/,
                   /\A\/categories\/([^\/?#]+)\/contacts\z/,
                   /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\z/,
                   /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\/edit\z/ ]
      { request_path: path,
        route_matchers: routes,
        view_variables: view_variables }
    end

    describe "#to_html" do
      it "has single unlinked breadcrumb if page is home" do
        config = configure("/")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item active">Home</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for simple path" do
        config = configure("/about")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">About</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to resource index page" do
        config = configure("/contacts")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">Contacts</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to specific resource" do
        config = configure("/contacts/28")
        breadcrumb_html = Breadcrumbs.new(config).to_html
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
        config = configure("/contacts/new")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">New Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to edit specific resource" do
        config = configure("/contacts/28/edit")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
            <li class="breadcrumb-item"><a href="/contacts/28">Contact</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to nested resource index page" do
        config = configure("/categories/5/contacts")
        breadcrumb_html = Breadcrumbs.new(config).to_html
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
        config = configure("/categories/5/contacts/10")
        breadcrumb_html = Breadcrumbs.new(config).to_html
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
        config = configure("/categories/5/contacts/new")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">New Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "returns proper html for path to edit specific nested resource" do
        config = configure("/categories/5/contacts/10/edit")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Contact</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "properly handles path to nested resource with undefined index view routes" do
        routes = [ /\A\/categories\/([^\/?#]+)\z/,
                   /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\z/,
                   /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\/edit\z/ ]
        view_variables = [{:name => :contact, :value => {:name=>"Eli"}}]
        config = configure("/categories/5/contacts/10/edit", routes, view_variables)                   
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Eli</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end
    end
  end
end
