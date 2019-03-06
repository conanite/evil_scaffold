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
  module Configurable
    attr_accessor :evil
  end

  class Configuration
    attr_accessor :klass, :names, :model_name, :models_name, :model_class_name
    attr_accessor :no_filter, :ordering_scope, :code

    def for? name
      names.include? name
    end

    def as name
      self.model_name = name
    end

    def order scope_name
      self.ordering_scope = scope_name
    end

    def install new_code, file, line
      self.code = [code.to_s, "\n# #{file}:#{line}", new_code].join("\n")
      klass.class_eval new_code, file, line
    end
  end

  def acts_as_evil target_model, action_names, options={}
    extend Configurable
    self.evil = config = Configuration.new
    config.klass              = self
    config.names              = Set.new action_names
    config.model_class_name   = target_model.name
    config.model_name         = config.model_class_name.underscore
    GENERATORS.each { |gen| gen.prepare config }

    options.each { |k,v| config.send k, v }
    yield config if block_given?
    config.models_name    ||= config.model_name.pluralize

    GENERATORS.each { |gen| gen.install config }
  end
end
