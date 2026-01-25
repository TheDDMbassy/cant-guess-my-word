require "test_helper"

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solution = solutions(:three)
  end

  test "should get index" do
    get solutions_url
    assert_response :success
  end

  test "should get new" do
    get new_solution_url
    assert_response :success
  end

  test "should create solution" do
    assert_difference("Solution.count") do
      post solutions_url, params: { solution: { elapsed_time: @solution.elapsed_time, guesser_name: @solution.guesser_name, guesses: @solution.guesses, puzzle_id: @solution.puzzle_id, status: @solution.status } }
    end

    assert_redirected_to solution_url(Solution.last)
  end

  test "should show solution" do
    get solution_url(@solution)
    assert_response :success
  end

  test "should update solution" do
    patch solution_url(@solution), params: { solution: { elapsed_time: @solution.elapsed_time, guesser_name: @solution.guesser_name, guesses: @solution.guesses, puzzle_id: @solution.puzzle_id, status: @solution.status } }
    assert_redirected_to solution_url(@solution)
  end

  test "should destroy solution" do
    assert_difference("Solution.count", -1) do
      delete solution_url(@solution)
    end

    assert_redirected_to solutions_url
  end
end
