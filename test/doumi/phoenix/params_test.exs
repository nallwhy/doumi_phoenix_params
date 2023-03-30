defmodule Doumi.Phoenix.ParamsTest do
  use ExUnit.Case
  alias Doumi.Phoenix.Params

  defmodule Test do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:foo, :string)
    end

    def changeset(params) do
      %__MODULE__{}
      |> cast(params, [:foo])
      |> validate_required([:foo])
    end
  end

  describe "to_params/2" do
    test "returns params from changeset" do
      changeset = Test.changeset(%{foo: "bar"})

      assert Params.to_params(changeset) == %{"foo" => "bar"}
    end

    test "returns params from form" do
      form = Test.changeset(%{foo: "bar"}) |> Phoenix.Component.to_form()

      assert Params.to_params(form) == %{"foo" => "bar"}
    end

    test "returns params merged with more_params" do
      changeset = Test.changeset(%{foo: "bar"})

      assert Params.to_params(changeset, %{"bar" => "baz"}) == %{"foo" => "bar", "bar" => "baz"}
    end
  end

  describe "to_form/3" do
    test "returns form from params and changeset_fun" do
      params = %{"foo" => "bar"}

      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = source} =
               Params.to_form(params, &Test.changeset/1)

      assert source.action == :validate
      assert source.changes == %{foo: "bar"}
    end

    test "returns form from params and module" do
      params = %{"foo" => "bar"}

      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = source} = Params.to_form(params, Test)
      assert source.action == :validate
      assert source.changes == %{foo: "bar"}
    end

    test "returns form from params and module with validate: false" do
      params = %{"foo" => "bar"}

      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = source} =
               Params.to_form(params, Test, validate: false)

      assert source.action == nil
      assert source.changes == %{foo: "bar"}
    end

    test "returns form from params and module with opts" do
      params = %{"foo" => "bar"}

      assert %Phoenix.HTML.Form{source: %Ecto.Changeset{} = source} =
               form = Params.to_form(params, Test, id: :test_id, name: :test_name, as: :test_as)

      assert source.action == :validate
      assert source.changes == %{foo: "bar"}
      assert form.id == :test_id
      assert form.name == "test_as"
      assert form.options |> Keyword.get(:id) == :test_id
      assert form.options |> Keyword.get(:name) == :test_name
    end
  end
end
