require "spec_helper"

describe EasyBreadcrumbs do
  it "has a version number" do
    expect(EasyBreadcrumbs::VERSION).not_to be nil
  end

  Breadcrumbs = EasyBreadcrumbs::Breadcrumbs
  Configuration = Struct.new(:request_path, :route_matchers, :view_variables)

  describe Breadcrumbs do
    it "requires an `options` argument on instantiation" do
      expect { Breadcrumbs.new }.to raise_error(ArgumentError)
    end

    describe "#to_html" do
      it "has single unlinked breadcrumb if page is home" do
        config = configure(path: "/")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item active">Home</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles simple path" do
        config = configure(path: "/about")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">About</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to resource index page" do
        config = configure(path: "/contacts")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">Contacts</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to specific resource" do
        config = configure(path: "/contacts/28")
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

      it "handles path to specific resource with auto detected name for hash" do
        config = configure(path: "/contacts/28", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">Ada Lovelace</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to specific resource with auto detected name for custom object" do
        config = configure(path: "/contacts/28", view_variables: default_custom_object_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">Ada Lovelace</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to resource new view" do
        config = configure(path: "/contacts/new")
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

      it "handles path to edit specific resource" do
        config = configure(path: "/contacts/28/edit")
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

      it "handles path to edit specific resource with auto detected name" do
        config = configure(path: "/contacts/28/edit", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/contacts">Contacts</a></li>
            <li class="breadcrumb-item"><a href="/contacts/28">Ada Lovelace</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to nested resource index page" do
        config = configure(path: "/categories/5/contacts")
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

      it "handles path to nested resource index page with auto detected parent resource name" do
        config = configure(path: "/categories/5/contacts", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Friends</a></li>
            <li class="breadcrumb-item active">Contacts</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to specific nested resource" do
        config = configure(path: "/categories/5/contacts/10")
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

      it "handles path to specific nested resource with auto detected names" do
        config = configure(path: "/categories/5/contacts/10", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Friends</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">Ada Lovelace</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to nested resource new view" do
        config = configure(path: "/categories/5/contacts/new")
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

      it "handles path to nested resource new view with auto detected names" do
        config = configure(path: "/categories/5/contacts/new", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Friends</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
            <li class="breadcrumb-item active">New Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to edit specific nested resource" do
        config = configure(path: "/categories/5/contacts/10/edit")
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

      it "handles path to edit specific nested resource with auto detected names" do
        config = configure(path: "/categories/5/contacts/10/edit", view_variables: default_hash_view_variables)
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Friends</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts">Contacts</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Ada Lovelace</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to nested resource with undefined index view routes" do
        config = configure(path: "/categories/5/contacts/10/edit", routes: missing_some_routes)                   

        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Category</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Contact</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "handles path to nested resource with undefined index view routes" do
        config = configure({path: "/categories/5/contacts/10/edit",
                            routes: missing_some_routes,
                            view_variables: default_hash_view_variables})                   

        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="/categories/5">Friends</a></li>
            <li class="breadcrumb-item"><a href="/categories/5/contacts/10">Ada Lovelace</a></li>
            <li class="breadcrumb-item active">Edit Contact</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "doesn't prefix anchor for top level /new directory with 'New'" do
        config = configure(path: "/new")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">New</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      it "doesn't prefix anchor for top level /edit directory with 'Edit'" do
        config = configure(path: "/edit")
        breadcrumb_html = Breadcrumbs.new(config).to_html
        expected_html = <<~HTML.chomp
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">Edit</li>
          </ol>
        HTML
        expect(breadcrumb_html).to eq(expected_html)
      end

      def configure(options)
        path = options.fetch(:path, "/")
        routes = options.fetch(:routes, default_routes)
        view_variables = options.fetch(:view_variables, [])
        
        Configuration.new(path, routes, view_variables)
      end

      def default_hash_view_variables
        [{:name => :contact, :value => {:name => "Ada Lovelace"}}, 
         {:name => :category, :value => {:name => "Friends"}}]
      end

      Contact = Struct.new(:name)
      Category = Struct.new(:name)

      def default_custom_object_view_variables
        contact = Contact.new("Ada Lovelace")
        category = Category.new("Friends")
        
        [{:name => :contact, :value => contact }, 
         {:name => :category, :value => category}]
      end

      def default_routes
        [/\A\/\z/,
         /\A\/new\z/,
         /\A\/edit\z/,
         /\A\/contacts\/new\z/,
         /\A\/contacts\/([^\/?#]+)\z/,
         /\A\/contacts\/([^\/?#]+)\/edit\z/,
         /\A\/categories\/new\z/,
         /\A\/categories\/([^\/?#]+)\z/,
         /\A\/about\z/, /\A\/contacts\z/,
         /\A\/categories\z/,
         /\A\/categories\/([^\/?#]+)\/contacts\z/,
         /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\z/,
         /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\/edit\z/]
      end

      def missing_some_routes
        [/\A\/categories\/([^\/?#]+)\z/,
         /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\z/,
         /\A\/categories\/([^\/?#]+)\/contacts\/([^\/?#]+)\/edit\z/]
      end
    end
  end
end
