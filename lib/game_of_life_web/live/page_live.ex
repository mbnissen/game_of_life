defmodule GameOfLifeWeb.PageLive do
  use GameOfLifeWeb, :live_view

  alias GameOfLife.GameServer
  alias GameOfLife.Board
  alias GameOfLife.Figure

  @speed 1000

  @impl true
  def render(assigns) do
    ~H"""
    <%= for y <- 1..@board.rows do %>
      <div class="flex flex-row">
        <%= for x <- 1..@board.cols do %>
          <div class={Board.populated?(@board, {x,y}) && "bg-black p-2 border-2" || "p-2 border-2"}>
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @speed)

    GameServer.start(20, 20)

    board = GameServer.populate_figure(Figure.simple(), offset_x: 0, offset_y: 0)

    {:ok,
     socket
     |> assign(board: board)}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @speed)
    {:noreply, assign(socket, :board, GameServer.iterate())}
  end
end
