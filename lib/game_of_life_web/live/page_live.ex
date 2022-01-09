defmodule GameOfLifeWeb.PageLive do
  use GameOfLifeWeb, :live_view

  alias GameOfLife.Board
  alias GameOfLife.Figure

  @speed 100

  @impl true
  def render(assigns) do
    ~H"""
    <%= for y <- 1..@board.rows do %>
      <div class="flex flex-row">
        <%= for x <- 1..@board.cols do %>
          <div class={Board.populated?(@board, {x,y}) && "bg-black pl-1 pt-1 border" || "pl-1 pt-1 border"}>
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @speed)

    board =
      Board.new(150, 100)
      |> Board.populate_figure(Figure.spaceship(), offset_x: 50, offset_y: 50)

    {:ok,
     socket
     |> assign(board: board)}
  end

  @impl true
  def handle_info(:update, %{assigns: %{board: board}} = socket) do
    Process.send_after(self(), :update, @speed)
    {:noreply, assign(socket, :board, Board.iterate(board))}
  end
end
