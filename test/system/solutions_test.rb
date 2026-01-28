require "application_system_test_case"

class SolutionsTest < ApplicationSystemTestCase
  setup do
    @solution = solutions(:solved)
  end

  test "visiting the index" do
    visit solutions_url
    assert_selector "h1", text: "Solutions"
  end

  test "should create solution" do
    visit solutions_url
    click_on "New solution"

    fill_in "Elapsed time", with: @solution.elapsed_time
    fill_in "Guesser name", with: @solution.guesser_name
    fill_in "Guesses", with: @solution.guesses
    fill_in "Puzzle", with: @solution.puzzle_id
    fill_in "Status", with: @solution.status
    click_on "Create Solution"

    assert_text "Solution was successfully created"
    click_on "Back"
  end

  test "should update Solution" do
    visit solution_url(@solution)
    click_on "Edit this solution", match: :first

    fill_in "Elapsed time", with: @solution.elapsed_time
    fill_in "Guesser name", with: @solution.guesser_name
    fill_in "Guesses", with: @solution.guesses
    fill_in "Puzzle", with: @solution.puzzle_id
    fill_in "Status", with: @solution.status
    click_on "Update Solution"

    assert_text "Solution was successfully updated"
    click_on "Back"
  end

  test "should destroy Solution" do
    visit solution_url(@solution)
    accept_confirm { click_on "Destroy this solution", match: :first }

    assert_text "Solution was successfully destroyed"
  end
end
