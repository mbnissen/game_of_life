defmodule GameOfLife.GameServer do
  use GenServer

  alias GameOfLife.Board

  def start(cols, rows) do
    GenServer.start_link(__MODULE__, {cols, rows}, name: __MODULE__)
  end

  def populate_figure(figure, options \\ []) do
    GenServer.call(__MODULE__, {:populate_figure, figure, options})
  end

  def iterate() do
    GenServer.call(__MODULE__, {:iterate})
  end

  @impl true
  def init({cols, rows}) do
    {:ok, Board.new(cols, rows)}
  end

  @impl true
  def handle_call({:populate_figure, figure, options}, _, board) do
    new_board = Board.populate_figure(board, figure, options)
    {:reply, new_board, new_board}
  end

  @impl true
  def handle_call({:iterate}, _, board) do
    new_board = Board.iterate(board)
    {:reply, new_board, new_board}
  end
end
