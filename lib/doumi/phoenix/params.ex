defmodule Doumi.Phoenix.Params do
  defmacro __using__(opts) do
    quote do
      def to_form(params, opts \\ []) do
        opts = unquote(opts) |> Keyword.merge(opts)

        unquote(__MODULE__).to_form(struct(__MODULE__), params, opts)
      end
    end
  end

  @doc """
  Converts params to form.
  """
  @spec to_form(struct :: struct(), params :: map(), opts :: keyword()) ::
          form :: Phoenix.HTML.Form.t()
  def to_form(%module{} = struct, params, opts \\ []) when is_struct(struct) and is_map(params) do
    {validate, opts} = opts |> Keyword.pop(:validate, true)
    {changeset_fun, opts} = opts |> Keyword.pop(:with, &module.changeset/2)

    struct
    |> changeset_fun.(params)
    |> do_validate(validate)
    |> Phoenix.Component.to_form(opts)
  end

  @doc """
  Converts form or changeset to params(map with string keys).
  """
  @spec to_params(
          form_or_changeset :: Phoenix.HTML.Form.t() | Ecto.Changeset.t(),
          more_params :: map()
        ) ::
          params :: map()
  def to_params(form_or_changeset, more_params \\ %{})

  def to_params(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset}, more_params) do
    to_params(changeset, more_params)
  end

  def to_params(%Ecto.Changeset{} = changeset, more_params) do
    changeset.params
    |> keys_to_string()
    |> Map.merge(more_params)
  end

  @doc """
  Converts form or changeset to map(map with atom keys).
  """
  @spec to_map(form_or_changeset :: Phoenix.HTML.Form.t() | Ecto.Changeset.t()) ::
          map :: map()
  def to_map(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset}) do
    to_map(changeset)
  end

  def to_map(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.apply_changes()
    |> struct_to_map()
  end

  defp do_validate(%Ecto.Changeset{} = changeset, true) do
    changeset
    |> Map.put(:action, :validate)
  end

  defp do_validate(%Ecto.Changeset{} = changeset, false) do
    changeset
  end

  def struct_to_map(%module{} = struct) when is_struct(struct) do
    embeds = module.__schema__(:embeds)

    map = struct |> Map.from_struct()

    embeds
    |> Enum.reduce(map, fn embed, acc ->
      Map.update!(acc, embed, &struct_to_map(&1))
    end)
  end

  def struct_to_map(list) when is_list(list) do
    list |> Enum.map(&struct_to_map/1)
  end

  def struct_to_map(value) do
    value
  end

  defp keys_to_string(%{} = atom_key_map) do
    atom_key_map
    |> Enum.map(fn {key, value} ->
      {to_string(key), keys_to_string(value)}
    end)
    |> Map.new()
  end

  defp keys_to_string(list) when is_list(list) do
    list |> Enum.map(&keys_to_string/1)
  end

  defp keys_to_string(value) do
    value
  end
end
