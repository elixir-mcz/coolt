defmodule Coolt.AccountsTest do
  use Coolt.DataCase

  alias Coolt.Accounts

  describe "users" do
    alias Coolt.Accounts.User

    @valid_attrs %{email: "some@email.com", name: "some name", password: "some password", uuid: "7488a646-e31f-11e4-aace-600308960662", avatar: "simplesavatar.com"}
    @update_attrs %{email: "some@updated.email", name: "some updated name", password: "some updated password", uuid: "7488a646-e31f-11e4-aace-600308960668", avatar: "simplesavatar.com"}
    @invalid_attrs %{email: nil, name: nil, password: nil, uuid: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert user.avatar == "simplesavatar.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some@updated.email"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert user.avatar == "simplesavatar.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "groups" do
    alias Coolt.Accounts.User
    alias Coolt.Accounts.Group

    @valid_attrs %{description: "some description", title: "some title", lng: "44.122123", lat: "-12.312221"}
    @update_attrs %{description: "some updated description", title: "some updated title", lng: "44.122123", lat: "-12.312221"}
    @invalid_attrs %{description: nil, title: nil}
    @valid_user_attrs %{email: "some@email.com", name: "some name", password: "some password", uuid: "7488a646-e31f-11e4-aace-600308960662", avatar: "simplesavatar.com"}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_group()

      group
    end

    test "list_groups/1 returns all groups in radius" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      assert Accounts.list_groups({-44.1231, 12.1233, 5000, user}) == []
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Accounts.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Accounts.create_group(@valid_attrs)
      assert group.description == "some description"
      assert group.title == "some title"
      assert group.lng == 44.122123
      assert group.lat == -12.312221
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = Accounts.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.description == "some updated description"
      assert group.title == "some updated title"
      assert group.lng == 44.122123
      assert group.lat == -12.312221
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_group(group, @invalid_attrs)
      assert group == Accounts.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Accounts.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Accounts.change_group(group)
    end

    test "groups_by_user/1 returns groups joineds and groups owner" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      group = Accounts.groups_by_user(user)
      assert group.groups_user_owner == []
      assert group.groups_joined == []
    end
  end
end
