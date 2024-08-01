defmodule ChatWeb.DashboardLive do
  use ChatWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end


  def render(assigns) do
    ~H""" 
      <div>
        <h1>Dashboard</h1>
      </div>
    """
  end
end
