defmodule ChatWeb.IndexLive do
  use ChatWeb, :live_view 

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <div class="text-center">
        <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
          Welcome to <span class="text-yellow-400">Chat</span>!
        </h1>
        <p class="text-xl mt-2">
          This is a simple chat application built with Phoenix LiveView.
        </p>
        <p>
          To get started, create an account and start chatting! 
        </p>
      </div> 
      <div class="mt-5 flex justify-center flex-col text-center gap-6 items-center">
        <.link
          patch={~p"/users/register"} 
          class="rounded-lg bg-yellow-400 text-2xl p-2 text-gray-950 hover:bg-yellow-300 transition ease-in-out"
        >
          Create an account
        </.link>
        <.link
          patch={~p"/users/log_in"} 
          class="rounded-lg text-yellow-400 text-2xl p-2 bg-gray-950 hover:bg-gray-700 transition ease-in-out"
        >
          Log in 
        </.link>
      </div>
    </div>
    """ 
  end
end
