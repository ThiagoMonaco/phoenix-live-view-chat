defmodule ChatWeb.CreateAccount.CreateAccountLive do
  alias Chat.Accounts
  alias Chat.Accounts.Account
  use ChatWeb, :live_view 
  
  def mount(_params, _session, socket) do
    changeset = Accounts.change_account(%Account{})
    {:ok, assign(socket, :form, to_form(changeset))}
  end
  
  def handle_event("validate", %{"account" => params}, socket) do
    changeset =
      %Account{}
      |> Accounts.change_account(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end 

  def handle_event("save", %{"account" => params}, socket) do
    case Accounts.create_account(params) do
      {:ok, _account} ->
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end 
  end

  def render(assigns) do
    ~H"""
      <div class="container flex flex-col items-center gap-6">
        <h1 class="text-center text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
          Create an account 
        </h1>
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
        <.link navigate={~p"/login"}class="text-lg flex flex-col items-center group">
          Already have an account  
          <div class="w-1/2 bg-gray-900 h-1.5 rounded transition-all duration-700 group-hover:w-full group-hover:bg-yellow-400"/>
        </.link>
      </div>
    """
  end
end
