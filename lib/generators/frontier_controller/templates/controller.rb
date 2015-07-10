class <%= controller_name_and_superclass %>

<% if model_configuration.show_index? -%>
  def index
    authorize(<%= model_configuration.as_constant %>)
    <%= model_configuration.ivar_collection %> = sort(policy_scope(<%= model_configuration.as_constant %>.all)).page(params[:page])
  end

<% end -%>
<% if model_configuration.show_create? -%>
  def new
    <%= model_configuration.ivar_instance %> = <%= model_configuration.as_constant %>.new
    authorize(<%= model_configuration.ivar_instance %>)
  end

  def create
    <%= model_configuration.ivar_instance %> = <%= model_configuration.as_constant %>.new(strong_params_for(<%= model_configuration.as_constant %>))
    <%= model_configuration.ivar_instance %>.save if authorize(<%= model_configuration.ivar_instance %>)

    respond_with(<%= model_configuration.ivar_instance %>, location: <%= model_configuration.url_builder.index_path %>)
  end

<% end -%>
<% if model_configuration.show_update? -%>
  def edit
    <%= model_configuration.ivar_instance %> = find_<%= model_configuration.model_name %>
    authorize(<%= model_configuration.ivar_instance %>)
  end

  def update
    <%= model_configuration.ivar_instance %> = find_<%= model_configuration.model_name %>
    <%= model_configuration.ivar_instance %>.assign_attributes(strong_params_for(<%= model_configuration.ivar_instance %>))
    <%= model_configuration.ivar_instance %>.save if authorize(<%= model_configuration.ivar_instance %>)

    respond_with(<%= model_configuration.ivar_instance %>, location: <%= model_configuration.url_builder.index_path %>)
  end

<% end -%>
<% if model_configuration.show_delete? -%>
  def destroy
    <%= model_configuration.ivar_instance %> = find_<%= model_configuration.model_name %>
    authorize(<%= model_configuration.ivar_instance %>)
    <%= model_configuration.ivar_instance %>.destroy
    respond_with(<%= model_configuration.ivar_instance %>, location: <%= model_configuration.url_builder.index_path %>)
  end

<% end -%>
<% if model_configuration.show_create? || model_configuration.show_update? || model_configuration.show_delete? -%>
private

  def find_<%= model_configuration.model_name %>
    <%= model_configuration.as_constant %>.find(params[:id])
  end
<% end -%>
end