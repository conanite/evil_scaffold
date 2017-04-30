# EvilScaffold

This gem provides the `acts_as_evil` method for Rails 4.0 controllers. It may work with later railses, patches welcome if not.

`acts_as_evil` generates action methods in your controller, and makes a bunch of assumptions about how you want your actions to behave.

It is evil, because according to some people, you should be able to see all the code in your application.

Differences between traditional Rails scaffolds, and `acts_as_evil` :

### `acts_as_evil`

* Generates code at runtime, so you never see the generated code (unless you debug it)
* Makes a bunch of assumptions about how your actions should behave
* Has a ton of undocumented configuration options
* Requires either a lot of trust, or an inspection of the generated code

### Rails scaffolds

* Generate controller class files that you then manipulate at will and check into your code repository
* Generate very simple methods that are easy to understand and use
* Are better documented

People will readily agree that traditional Rails scaffolds are better in almost all cases. Here are two strong justifications for using `evil_scaffold` :

* Either you are the author of the gem and understand its features intimately, remaining blissfully unaware of its defects, or
* You have an overwhelming, chronic obsession with minimizing your LOC count and will sacrifice all readability to this end.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evil_scaffold'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evil_scaffold

## Usage

Read the code and figure it out. Here are some examples:

Generate a #new action and a #create action

```ruby
acts_as_evil Post, :new, :create
```

Both actions will instantiate a variable called `@post`. `new` will instantiate a new Post and render the `new` template. `create` will instantiate a new Post, call `save` on it, and then `redirect_to params[:return_to]`

Here is a more complete example:

```ruby
acts_as_evil Contact, :index, :index_json, :new, :create, :show, :edit, :update, :delete, :destroy, :finder, :goto_show
```

The variable this time is called `@contact`. `index_json` is called from the `index` action when the requested content-type is `json`. `finder` is not an action but rather a one-line `before_filter` (or `before_action`)

```ruby
def find_contact
  @contact = Contact.find params[:id]
end
```

`find_contact` is installed as a `before_filter` for all "member" actions (`show`, `edit`, `delete`)

You can install your finder as a `before_filter` for other actions in the configuration block:

```ruby
acts_as_evil Comment, :edit, :update, :delete, :destroy, :finder do |config|
  config.finder_filter_actions << :approve
end
```

This does not create the `approve` action, but includes it in the line

```ruby
before_filter :find_comment, only: %i{ edit update delete approve }
```

`evil_scaffold` doesn't make any assumptions about the order of items in your `index` action ; it will assign items using the backing store's native ordering. You can control this by telling `acts_as_evil` to call a particular scope definition on your model:

```ruby
acts_as_evil Invoice, :index do |config|
  config.ordering_scope = :order_by_date_desc
end
```

This will insert somewhere inside your `index` action

```ruby
@invoices = @invoices.order_by_date_desc
```

Finally, if you have a really awkward long model class name, you can avoid embarassment using `model_name`:

```ruby
acts_as_evil Cms::Post::Comment, :index, :new, :create, :show, :delete, :destroy, :finder, :goto_show do |config|
  config.model_name = "comment"
end
```

This will create a variable called `@comment` instead of `@cms_post_comment` which would risk inviting snickering from your colleagues.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/evil_scaffold/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
