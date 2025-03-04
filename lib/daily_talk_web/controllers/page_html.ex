defmodule DailyTalkWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DailyTalkWeb, :html

  embed_templates "page_html/*"
end
