defmodule GameOfLifeWeb.BoardTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Board
  alias GameOfLife.Figure

  describe "board" do
    test "should get cell value" do
      board =
        Board.new(5, 5)
        |> Board.populate_cell({1, 1})

      assert true == Board.populated?(board, {1, 1})

      assert false == Board.populated?(board, {1, 2})
    end

    test "should die if 0 or 1 neighbors" do
      board =
        Board.new(5, 5)
        |> Board.populate_cell({1, 1})
        |> Board.populate_cell({2, 2})
        |> Board.populate_cell({4, 4})

      new_board = Board.iterate(board)

      assert false == Board.populated?(new_board, {1, 1})
      assert false == Board.populated?(new_board, {2, 2})
      assert false == Board.populated?(new_board, {4, 4})
    end

    test "should populate figure and iterate (simple)" do
      Board.new(5, 5)
      |> Board.populate_figure(Figure.simple())
      |> Board.iterate()
    end

    test "should populate figure and iterate (large)" do
      Board.new(400, 300)
      |> Board.populate_figure(Figure.spaceship(), offset_x: 0, offset_y: 0)
      |> Board.iterate()
    end
  end
end
