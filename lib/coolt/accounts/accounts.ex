defmodule Coolt.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Coolt.Repo
  alias Ueberauth.Auth
  alias Coolt.Accounts.User
  alias Coolt.Accounts.UserGroup
  alias Coolt.Accounts.Group
  alias Coolt.Accounts.GroupImage

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
  @doc """
  This function find or create data in db for the auth

  ## Examples

      iex> find_or_create(auth)
      {:ok, %Auth{}}

      
      iex> find_or_create(auth)
      {:error, "User not found"}
  """
  def find_or_create(%Auth{provider: :identity} = auth) do
   case Repo.get_by(User, email: auth.info.email) do
      %User{} = user ->
        {:ok, user}
       nil -> 
        basic_info(auth)
        |> register_new_user()
    end
  end

  def find_or_create(%Auth{} = auth) do # TODO: Maybe change this for one function
    case Repo.get_by(User, email: auth.info.email) do
      %User{} = user ->
        {:ok, user}
      nil -> 
        basic_info(auth)
        |> register_new_user()
    end
  end

  def find_or_create(%User{} = user) do # TODO: implement standard auth
    {:ok, user}
  end

 @doc """
  This function return basic info data of auth user

  ## Examples

      iex> basic_info(auth)
      %{name: name_from_auth(auth), avatar: auth.info.image, email: auth.info.email}
  """
  def basic_info(%User{} = user, :basic) do
    %{name: user.name, avatar: user.avatar, email: user.email}
  end

  def basic_info(auth) do
    %User{name: name_from_auth(auth), avatar: auth.info.image, email: auth.info.email}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  defp register_new_user(%User{} = user) do
    user
    |> Repo.insert()
  end

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end
  @doc """
  Gets groups by user.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> groups_by_user(user)
      %{
        groups_joined: [%Group{}, %Group{}],
        groups_user_owner: [%Group{}, %Group{}]
      }

  """
  def groups_by_user(%User{} = user) do
    group_query_with_img = from(
      g in Group,
      left_join: i in GroupImage,
        on: i.group_id == g.id,
        on: i.default_image == true,
      select: %{
        id: g.id, 
        title: g.title,
        description: g.description,
        default_image: i.url
      })

    groups_user_owner = from(g in group_query_with_img,  where: g.user_id == ^user.id) |> Repo.all()

    groups_joined_list = from( # TODO: convert this in one unique query
      ug in UserGroup,
      select: ug.group_id,
      where: ug.user_id == ^user.id,
    ) |> Repo.all()

    groups_joined = from(g in group_query_with_img, where: g.id in ^groups_joined_list)|> Repo.all()

    %{
      groups_user_owner: groups_user_owner,
      groups_joined: groups_joined
    }
     
  end
end
