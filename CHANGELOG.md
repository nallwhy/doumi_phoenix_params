# Changelog

## v0.3.2 (2023-05-20)

- Fix handling not casted embeded fields

## v0.3.1 (2023-05-19)

- Fixed failure to support `embeds_many/3`

## v0.3.0 (2023-05-18)

### Enhancements

- Add `__using__1` that creates `to_form/2` to schema modules.

## v0.2.0 (2023-03-31)

### Enhancements

- Support embedded schemas in `to_params/3`, `to_form/3`.
- Add `to_map/1` that converts `%Phoenix.HTML.Form{}` or `%Ecto.Changeset{}` to map.
