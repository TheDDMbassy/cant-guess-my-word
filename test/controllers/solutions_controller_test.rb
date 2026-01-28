require "test_helper"

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solution = solutions(:three)
  end

  test "should get index" do
    get solutions_url
    assert_response :success
    assert_match "Leaderboard", @response.body
    assert_match "bing_bong_68", @response.body
  end

  test "should get new" do
    get new_solution_url
    assert_response :success
    assert_match "Puzzle for", @response.body
  end

  test "should create solution" do
    assert_difference("Solution.count") do
      # Simulate mobile users with the capital letter and trailing space
      post solutions_url, params: { solution: { puzzle_id: puzzles(:one).id, user_guess: "Apple " } }
    end

    solution = Solution.last

    assert_redirected_to solution_url(solution)

    assert solution.guessing?, "Solution should be in the 'guessing' state"
    assert_equal "apple", solution.guesses
    assert_equal "apple", solution.most_recent_guess
  end

  test "should show solution -- guessing" do
    get solution_url(@solution)
    assert_response :success

    assert_match "is after:", @response.body
    assert_match "middle", @response.body

    assert_match "is before:", @response.body
    assert_match "zany", @response.body

    assert_no_match "You got it!", @response.body
    assert_no_match "definition", @response.body
  end

  test "should show solution -- solved" do
    get solution_url(solutions(:solved))
    assert_response :success

    assert_match "is after:", @response.body
    assert_match "middle", @response.body

    assert_match "is before:", @response.body
    assert_match "zany", @response.body

    assert_match "You got it!", @response.body
    assert_match "definition", @response.body
  end


  test "should still create solution with instant correct guess" do
    assert_difference("Solution.count") do
      # Simulate mobile users with the capital letter and trailing space
      post solutions_url, params: { solution: { puzzle_id: puzzles(:one).id, user_guess: "Super " } }
    end

    solution = Solution.last

    assert_redirected_to solution_url(solution)

    assert solution.solved?, "Insta-guess! Solution should be in the 'solved' state"
    assert_equal "super", solution.guesses
    assert_equal "super", solution.most_recent_guess
    # Still need an assertion here for the page showing the "You got it!" message
  end

  test "should update solution with guesses" do
    assert_equal "middle zany", @solution.guesses
    assert_equal "zany", @solution.most_recent_guess

    patch guess_solution_url(@solution), params: { solution: { user_guess: "Apple ", puzzle_id: @solution.puzzle_id } }

    assert_redirected_to solution_url(@solution)
    assert_response :see_other

    @solution.reload
    assert_equal "middle zany apple", @solution.guesses
    assert_equal "apple", @solution.most_recent_guess
  end

  test "should not update solution if guess is not a real word" do
    patch guess_solution_url(@solution), params: { solution: { user_guess: "notarealword", puzzle_id: @solution.puzzle_id } }

    assert_response :unprocessable_entity
    assert_match "Guess must be an actual word", @response.body

    @solution.reload
    assert_equal "middle zany", @solution.guesses
    assert_equal "zany", @solution.most_recent_guess
  end

  test "should not update solution if guess has already been guessed" do
    patch guess_solution_url(@solution), params: { solution: { user_guess: "middle", puzzle_id: @solution.puzzle_id } }

    assert_response :unprocessable_entity
    assert_match "Oops, you've already guessed that word.", CGI.unescape_html(@response.body)

    @solution.reload
    assert_equal "middle zany", @solution.guesses
    assert_equal "zany", @solution.most_recent_guess
  end

  test "should be able to submit name" do
    solution = solutions(:solved)

    # Make sure the input gets stripped
    patch solution_url(solution), params: { solution: { guesser_name: " DDM ", puzzle_id: solution.puzzle_id } }

    assert_redirected_to solutions_url

    solution.reload
    assert_equal "DDM", solution.guesser_name
    assert_equal 2, solution.elapsed_time, "solution's elapsed time is not as expected"
  end

  test "should not be able to submit disallowed name" do
    solution = solutions(:solved)

    # Make sure the input gets stripped
    patch solution_url(solution), params: { solution: { guesser_name: "shit", puzzle_id: solution.puzzle_id } }

    assert_response :unprocessable_entity
    assert_template :solved
  end

  test "should measure elapsed time properly" do
    assert false
  end

  test "should destroy solution" do
    assert_difference("Solution.count", -1) do
      delete solution_url(@solution)
    end

    assert_redirected_to solutions_url
  end
end
