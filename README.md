# Doumi.Phoenix.Params

[![Hex Version](https://img.shields.io/hexpm/v/doumi_phoenix_params.svg)](https://hex.pm/packages/doumi_phoenix_params)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/doumi_phoenix_params/)
[![License](https://img.shields.io/hexpm/l/doumi_phoenix_params.svg)](https://github.com/nallwhy/doumi_phoenix_params/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/nallwhy/doumi_phoenix_params.svg)](https://github.com/nallwhy/doumi_phoenix_params/commits/main)

<!-- MDOC !-->

`Doumi.Phoenix.Params` is a helper library that convert form to params and params to form.

**도우미(Doumi)** means "helper" in Korean.

## Usage

```elixir
defmodule MyAppWeb.TestParams do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :foo, :string
  end

  @required [:foo]
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end

defmodule MyAppWeb.MyLive do
  use MyAppWeb, :live_view
  alias MyAppWeb.TestParams
  alias Doumi.Phoenix.Params

  ...

  @impl true
  def mount(_params, _session, socket) do
    form = %{} |> Params.to_form(TestParams, as: :test, validate: false)

    socket = socket |> assign(:form, form)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"test" => test_params}, socket) do
    form = test_params |> Params.to_form(TestParams, as: :test)

    socket = socket |> assign(:form, form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("change_foo_from_outside_of_form", %{"foo" => foo}, socket) do
    form =
      socket.assigns.form
      |> Params.to_params(%{"foo" => foo})
      |> Params.to_form(TestParams, as: :test)

    socket = socket |> assign(:form, form)

    {:noreply, socket}
  end

  ...
end
```

Here's the working example

- page: https://json.media/playgrounds/form
- code: https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/form_live.ex

## Installation

The package can be installed by adding `doumi_phoenix_params` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:doumi_phoenix_params, "~> 0.1.0"}
  ]
end
```

<!-- MDOC !-->

## Other Doumi packages

- [Doumi.Phoenix.SVG](https://github.com/nallwhy/doumi_phoenix_svg): A helper library that generates Phoenix function components from SVG files.
- [Doumi.URI.Query](https://github.com/nallwhy/doumi_uri_query): A helper library that encode complicated query of URI.

## Copyright and License

Copyright (c) 2023 Jinkyou Son (Json)

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
