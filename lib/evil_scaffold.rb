require "evil_scaffold/version"
require 'evil_scaffold/plugin'
require 'evil_scaffold/index_action'
require 'evil_scaffold/index_json'
require 'evil_scaffold/new_action'
require 'evil_scaffold/create_action'
require 'evil_scaffold/show_action'
require 'evil_scaffold/edit_action'
require 'evil_scaffold/update_action'
require 'evil_scaffold/delete_action'
require 'evil_scaffold/destroy_action'
require 'evil_scaffold/goto_show_method'
require 'evil_scaffold/return_appropriately_method'
require 'evil_scaffold/finder_method'

module EvilScaffold
  class Configuration
    attr_accessor :klass, :names, :model_name, :models_name, :model_class_name, :finder_filter_actions, :path_to_avoid_after_delete
    attr_accessor :no_filter, :ordering_scope

    def for? name
      names.include? name
    end

    def install code, file, line
      klass.class_eval code, file, line
    end
  end

  def acts_as_evil target_model, *action_names
    config                  = Configuration.new
    config.klass            = self
    config.names            = Set.new action_names
    config.model_class_name = target_model.name
    config.model_name       = config.model_class_name.underscore
    show_path               = name.underscore.sub(/_controller$/, '').gsub("/", "_").singularize
    config.finder_filter_actions = %i{ show edit update delete destroy }
    config.path_to_avoid_after_delete = show_path
    yield config if block_given?
    config.models_name    ||= config.model_name.pluralize

    GENERATORS.each do |gen|
      gen.install config
    end
  end
end
