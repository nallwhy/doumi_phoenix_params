defmodule Doumi.Phoenix.ParamsTest do
  use ExUnit.Case
  alias Doumi.Phoenix.Params

  defmodule Test do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :foo, :string

      embeds_one :embedded, Embedded, primary_key: false do
        field :bar, :string
      end
    end

    def changeset(%__MODULE__{} = struct \\ %__MODULE__{}, params) do
      struct
      |> cast(params, [:foo])
      |> validate_required([:foo])
      |> cast_embed(:embedded, required: true, with: &changeset_embedded/2)
    end

    def another_changeset(%__MODULE__{} = struct \\ %__MODULE__{}, params) do
      struct
      |> cast(params, [:foo])
      |> validate_required([:foo])
      |> append_foo_to_foo()
    end

    def changeset_embedded(%__MODULE__.Embedded{} = struct \\ %__MODULE__.Embedded{}, params) do
      struct
      |> cast(params, [:bar])
      |> validate_required([:bar])
    end

    defp append_foo_to_foo(%Ecto.Changeset{changes: changes, valid?: true} = changeset) do
      changeset
      |> put_change(:foo, changes.foo <> "foo")
    end
  end

  describe "to_params/2" do
    setup do
      %{changeset: Test.changeset(%{foo: "foo", embedded: %{bar: "bar"}})}
    end

    test "returns params from changeset", %{changeset: changeset} do
      assert Params.to_params(changeset) == %{"foo" => "foo", "embedded" => %{"bar" => "bar"}}
    end

    test "returns params from form", %{changeset: changeset} do
      form = changeset |> Phoenix.Component.to_form()

      assert Params.to_params(form) == %{"foo" => "foo", "embedded" => %{"bar" => "bar"}}
    end

    test "returns params merged with more_params", %{changeset: changeset} do
      assert Params.to_params(changeset, %{"baz" => "baz"}) == %{
               "foo" => "foo",
               "embedded" => %{"bar" => "bar"},
               "baz" => "baz"
             }
    end
  end

  describe "to_form/3" do
    setup do
      %{params: %{"foo" => "foo", "embedded" => %{"bar" => "bar"}}}
    end

    test "returns form from struct and params", %{params: params} do
      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset} =
               Params.to_form(%Test{}, params)

      assert changeset.action == :validate
      assert %{foo: "foo", embedded: %Ecto.Changeset{} = embedded_changeset} = changeset.changes
      assert %{bar: "bar"} = embedded_changeset.changes
    end

    test "returns form from struct and params with with option", %{params: params} do
      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset} =
               Params.to_form(%Test{}, params, with: &Test.another_changeset/2)

      assert changeset.action == :validate
      assert %{foo: "foofoo"} = changeset.changes
    end

    test "returns form from params and module with validate: false", %{params: params} do
      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset} =
               Params.to_form(%Test{}, params, validate: false)

      assert changeset.action == nil
      assert %{foo: "foo", embedded: %Ecto.Changeset{} = embedded_changeset} = changeset.changes
      assert %{bar: "bar"} = embedded_changeset.changes
    end
  end
end
