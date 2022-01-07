defmodule GameOfLifeWeb.FigureTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Figure

  describe "figure" do
    test "should get cell value" do
      Figure.spaceship()
    end
  end
end
