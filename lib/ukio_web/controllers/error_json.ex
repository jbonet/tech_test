defmodule UkioWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, assigns) do
    message =
      case Map.fetch(assigns, :custom_message) do
        {:ok, message} -> message
        _ -> Phoenix.Controller.status_message_from_template(template)
      end

    %{errors: %{detail: message}}
  end
end
