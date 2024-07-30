defmodule ChatWeb.AccountLiveTest do
  use ChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import Chat.AccountsFixtures

  @create_attrs %{name: "some name", password: "some password", email: "some email"}
  @update_attrs %{name: "some updated name", password: "some updated password", email: "some updated email"}
  @invalid_attrs %{name: nil, password: nil, email: nil}

  defp create_account(_) do
    account = account_fixture()
    %{account: account}
  end

  describe "Index" do
    setup [:create_account]

    test "lists all account", %{conn: conn, account: account} do
      {:ok, _index_live, html} = live(conn, ~p"/account")

      assert html =~ "Listing Account"
      assert html =~ account.name
    end

    test "saves new account", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/account")

      assert index_live |> element("a", "New Account") |> render_click() =~
               "New Account"

      assert_patch(index_live, ~p"/account/new")

      assert index_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#account-form", account: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/account")

      html = render(index_live)
      assert html =~ "Account created successfully"
      assert html =~ "some name"
    end

    test "updates account in listing", %{conn: conn, account: account} do
      {:ok, index_live, _html} = live(conn, ~p"/account")

      assert index_live |> element("#account-#{account.id} a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(index_live, ~p"/account/#{account}/edit")

      assert index_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#account-form", account: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/account")

      html = render(index_live)
      assert html =~ "Account updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes account in listing", %{conn: conn, account: account} do
      {:ok, index_live, _html} = live(conn, ~p"/account")

      assert index_live |> element("#account-#{account.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#account-#{account.id}")
    end
  end

  describe "Show" do
    setup [:create_account]

    test "displays account", %{conn: conn, account: account} do
      {:ok, _show_live, html} = live(conn, ~p"/account/#{account}")

      assert html =~ "Show Account"
      assert html =~ account.name
    end

    test "updates account within modal", %{conn: conn, account: account} do
      {:ok, show_live, _html} = live(conn, ~p"/account/#{account}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(show_live, ~p"/account/#{account}/show/edit")

      assert show_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#account-form", account: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/account/#{account}")

      html = render(show_live)
      assert html =~ "Account updated successfully"
      assert html =~ "some updated name"
    end
  end
end
