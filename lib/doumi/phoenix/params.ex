defmodule Doumi.Phoenix.Params do
  def to_params(form_or_changeset, more_params \\ %{})

  def to_params(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset}, more_params) do
    to_params(changeset, more_params)
  end

  def to_params(%Ecto.Changeset{} = changeset, more_params) do
    changeset.params
    |> Map.merge(more_params)
  end

  def to_form(params, module_or_changeset_fun, opts \\ [])

  def to_form(params, module, opts) when is_atom(module) do
    to_form(params, &module.changeset/1, opts)
  end

  def to_form(params, changeset_fun, opts) when is_function(changeset_fun, 1) do
    {validate, opts} = opts |> Keyword.pop(:validate, true)

    params
    |> changeset_fun.()
    |> do_validate(validate)
    |> Phoenix.Component.to_form(opts)
  end

  defp do_validate(%Ecto.Changeset{} = changeset, true) do
    changeset
    |> Map.put(:action, :validate)
  end

  defp do_validate(%Ecto.Changeset{} = changeset, false) do
    changeset
  end
end
