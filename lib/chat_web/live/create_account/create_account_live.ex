defmodule ChatWeb.CreateAccount.CreateAccountLive do
  alias Chat.Accounts
  alias Chat.Accounts.Account
  use ChatWeb, :live_view 
  
  def mount(_params, _session, socket) do
    changeset = Accounts.change_account(%Account{})
    {:ok, assign(socket, :form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
      <div class="container">
        <h1 class="text-center text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
          Account Creation
        </h1>
        <.form 
          class="flex w-full items-center flex-col mt-10"
          phx-submit="save" 
          phx-change="validate"
          for={@form}>
            <div class="flex w-1/2 justify-center flex-col">
              <label>Name</label>
              <.input class="" field={@form[:name]} placeholder="Name" />
            </div>
        </.form>
      </div>
    """
  end
end
