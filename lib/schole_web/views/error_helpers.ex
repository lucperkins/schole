defmodule ScholeWeb.ErrorHelpers do
  @moduledoc false

  use Phoenix.HTML

  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "help-block",
        data: [phx_error_for: input_id(form, field)]
      )
    end)
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(ScholeWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(ScholeWeb.Gettext, "errors", msg, opts)
    end
  end
end
