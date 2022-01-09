defmodule GameOfLife.Board do
  alias GameOfLife.Board

  defstruct [:cols, :rows, :cells]

  def new(cols, rows) do
    %Board{cols: cols, rows: rows, cells: %{}}
  end

  def populate_figure(%Board{} = board, figure, options \\ []) do
    offset_x = Keyword.get(options, :offset_x, 0)
    offset_y = Keyword.get(options, :offset_y, 0)

    new_cells =
      figure
      |> Enum.map(fn {x, y} -> {{x + offset_x, y + offset_y}, true} end)
      |> Map.new()

    %Board{board | cells: new_cells}
  end

  def populate_cell(%Board{} = board, position), do: update_cell(board, position, true)

  def update_cell(%Board{cells: cells} = board, {x, y}, populated \\ true) do
    new_cells = Map.put(cells, {x, y}, populated)

    %Board{board | cells: new_cells}
  end

  def populated?(%Board{cells: cells}, {x, y}) do
    Map.get(cells, {x, y}, false)
  end

  def iterate(%Board{} = board) do
    new_cells =
      board.cells
      |> Enum.map(fn {{x, y}, _} -> get_neighbors({x, y}) end)
      |> List.flatten()
      |> Enum.map(fn {x, y} -> {{x, y}, false} end)
      |> Map.new()
      |> Map.merge(board.cells)
      |> Enum.map(fn cell -> iterate_cell(board, cell) end)
      |> Enum.filter(fn {{_, _}, value} -> value end)
      |> Map.new()

    %Board{board | cells: new_cells}
  end

  def iterate_cell(%Board{} = board, {{x, y}, is_populated}) do
    becomes_populated =
      board
      |> get_populated_neighbor_count({x, y})
      |> becomes_populated?(is_populated)

    {{x, y}, becomes_populated}
  end

  defp becomes_populated?(2, true), do: true
  defp becomes_populated?(3, true), do: true
  defp becomes_populated?(3, false), do: true
  defp becomes_populated?(_, _), do: false

  defp get_neighbors({x, y}) do
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
  end

  defp get_populated_neighbor_count(%Board{} = board, {x, y}) do
    get_neighbors({x, y})
    |> Enum.filter(fn position -> populated?(board, position) end)
    |> length()
  end
end
