require "evil_scaffold/version"
require 'evil_scaffold/create_action'
require 'evil_scaffold/delete_action'
require 'evil_scaffold/destroy_action'
require 'evil_scaffold/edit_action'
require 'evil_scaffold/finder_method'
require 'evil_scaffold/goto_show_method'
require 'evil_scaffold/index_action'
require 'evil_scaffold/index_json'
require 'evil_scaffold/new_action'
require 'evil_scaffold/return_appropriately_method'
require 'evil_scaffold/show_action'
require 'evil_scaffold/update_action'
require 'evil_scaffold/version'

module EvilScaffold
  def acts_as_evil target_model, *action_names
    names = action_names.inject({ }) { |hsh, name| hsh[name.to_sym] = true; hsh }
    model_class_name = target_model.name
    model_name = model_class_name.underscore
    show_path = name.underscore.sub(/_controller$/, '').gsub("/", "_").singularize
    options = {
      finder_filter_actions: [:show, :edit, :update, :delete, :destroy],
      model_name: model_name,
      path_to_avoid_after_delete: show_path
    }
    yield options if block_given?
    model_name = options[:model_name]
    models_name = options[:models_name] || model_name.pluralize

    IndexAction.define_index(self, names[:no_filter], options[:ordering_scope], models_name, model_class_name) if names[:index]
    IndexJson.define_index_json(self, models_name) if names[:index_json]
    NewAction.define_new(self, model_name) if names[:new]
    CreateAction.define_create(self, model_name, model_class_name) if names[:create]
    ShowAction.define_show(self, model_name) if names[:show]
    EditAction.define_edit(self) if names[:edit]
    UpdateAction.define_update(self, model_name) if names[:update]
    DeleteAction.define_delete(self) if names[:delete]
    DestroyAction.define_destroy(self, model_name, options[:path_to_avoid_after_delete]) if names[:destroy]
    GotoShowMethod.define_goto_show(self, model_name) if names[:goto_show]
    ReturnAppropriatelyMethod.define_return_appropriately self, model_name
    FinderMethod.define_finder(self, model_name, model_class_name, options[:finder_filter_actions]) if names[:finder]
  end
end
