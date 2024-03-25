defmodule Forum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :hash_password, :string
    has_many :posts, Forum.Posts.Post
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :hash_password])
    |> validate_required([:name, :email, :hash_password])
    |> unique_constraint(:email)
  end
end
