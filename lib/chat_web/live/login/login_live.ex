defmodule ChatWeb.Login.LoginLive do
  alias Chat.Accounts.Account
  alias Chat.Accounts
  use ChatWeb, :live_view 

  def mount(_params, _session, socket) do
    changeset = Accounts.change_account(%Account{})
    {:ok, assign(socket, :form, to_form(changeset))}
  end
  
  def render(assigns) do
    ~H"""
      <div class="container">
        <h1 class="text-center text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl"> Login </h1> 
        <.form 
          phx-submit="save" 
          phx-change="validate"
          class="flex w-full items-center flex-col text-xl gap-6"
          for={@form}>
            <div class="flex sm:w-1/2 w-full justify-center flex-col gap-6">
              <.input phx-debounce="blur" label="Name" field={@form[:name]} placeholder="Name" />
              <.input phx-debounce="blur" label="Email" field={@form[:email]} placeholder="Email" />
              <.input type="password" phx-debounce="blur" label="Password" field={@form[:password]} placeholder="Password" />
            </div>
            <.button> 
              Create account
            </.button>
        </.form>
      </div>
    """
  end

end
