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
      post solutions_url, params: { solution: { puzzle_id: puzzles(:one).id, user_guess: "apple" } }
    end

    solution = Solution.last

    assert_redirected_to solution_url(solution)
    assert solution.guessing?, "Solution should be in the 'guessing' state"
    assert_equal "apple", solution.guesses
    assert_equal "apple", solution.most_recent_guess
  end

  test "should show solution" do
    get solution_url(@solution)
    assert_response :success
  end

  test "should update solution" do
    assert_equal "middle zany", @solution.guesses
    assert_equal "zany", @solution.most_recent_guess

    patch solution_url(@solution), params: { solution: { user_guess: "apple", puzzle_id: @solution.puzzle_id } }

    assert_redirected_to solution_url(@solution)

    @solution.reload
    assert_equal "middle zany apple", @solution.guesses
    assert_equal "apple", @solution.most_recent_guess
  end

  test "should destroy solution" do
    assert_difference("Solution.count", -1) do
      delete solution_url(@solution)
    end

    assert_redirected_to solutions_url
  end
end
