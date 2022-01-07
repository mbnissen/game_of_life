defmodule GameOfLife.Board do
  alias GameOfLife.Board

  defstruct [:cols, :rows, :cells]

  def new(cols, rows) do
    cells = for x <- 1..cols, y <- 1..rows, do: {x, y, false}

    %Board{cols: cols, rows: rows, cells: cells}
  end

  def populate_figure(%Board{} = board, figure, options \\ []) do
    offset_x = Keyword.get(options, :offset_x, 0)
    offset_y = Keyword.get(options, :offset_y, 0)

    figure
    |> Enum.map(fn {x, y} -> {x + offset_x, y + offset_y} end)
    |> Enum.reduce(board, fn position, updated_board ->
      populate_cell(updated_board, position)
    end)
  end

  def populate_cell(%Board{} = board, position), do: update_cell(board, position, true)

  def update_cell(%Board{cells: cells} = board, {x, y}, populated \\ true) do
    new_cells =
      Enum.map(cells, fn
        {^x, ^y, _} -> {x, y, populated}
        item -> item
      end)

    %Board{board | cells: new_cells}
  end

  def populated?(%Board{cells: cells}, {x, y}) do
    Enum.member?(cells, {x, y, true})
  end

  def iterate(%Board{} = board) do
    new_cells =
      board.cells
      |> Enum.map(fn cell -> iterate_cell(board, cell) end)

    %Board{board | cells: new_cells}
  end

  def iterate_cell(%Board{} = board, {x, y, is_populated}) do
    becomes_populated =
      board
      |> get_neighbors({x, y})
      |> becomes_populated?(is_populated)

    {x, y, becomes_populated}
  end

  defp becomes_populated?(2, true), do: true
  defp becomes_populated?(3, true), do: true
  defp becomes_populated?(3, false), do: true
  defp becomes_populated?(_, _), do: false

  defp get_neighbors(%Board{} = board, {x, y}) do
    [
      {x, y - 1},
      {x, y + 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x - 1, y - 1}
    ]
    |> Enum.filter(fn position -> populated?(board, position) end)
    |> length()
  end
end
