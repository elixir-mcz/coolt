defmodule CooltWeb.GroupView do
  use CooltWeb, :view
  alias CooltWeb.GroupView

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, GroupView, "group.json")}
  end

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{id: group.id,
      title: group.title,
      description: group.description}
  end
  def render("join.json", %{user_group: user_group}) do
    %{group_joined_id: user_group.group_id,
      status: user_group.status}
  end
end
