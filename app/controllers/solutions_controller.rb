class SolutionsController < ApplicationController
  before_action :set_solution, only: %i[ show update destroy guess ]
  before_action :set_user_guess, only: %i[ create update guess ]

  # GET /solutions or /solutions.json
  def index
    @solutions = Solution.all
  end

  # GET /solutions/1 or /solutions/1.json
  def show
  end

  # GET /solutions/new
  def new
    puzzle = Puzzle.find_by(day: Date.today)

    puzzle = Puzzle.last unless puzzle

    @solution = Solution.new(puzzle:)
  end

  # POST /solutions or /solutions.json
  def create
    # Don't guess the user_guess yet, need to persist the solution to the database first so that
    # the state machine can look up the correct answer.
    @solution = Solution.new(solution_params.except(:user_guess))

    respond_to do |format|
      @solution.guess!(@user_guess)

      format.html { redirect_to @solution }
      format.json { render :show, status: :created, location: @solution }

    rescue AASM::InvalidTransition
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @solution.errors, status: :unprocessable_entity }
    end
  end

  def update
  end

  # PATCH/PUT /solutions/1 or /solutions/1.json
  def guess
    respond_to do |format|
      @solution.guess!(@user_guess)
      format.html { redirect_to @solution, status: :see_other }
      format.json { render :show, status: :ok, location: @solution }
    rescue AASM::InvalidTransition
      format.html { render :show, status: :unprocessable_entity }
      format.json { render json: @solution.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /solutions/1 or /solutions/1.json
  def destroy
    @solution.destroy!

    respond_to do |format|
      format.html { redirect_to solutions_path, notice: "Solution was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_solution
      @solution = Solution.find(params.expect(:id))
    end

    def set_user_guess
      @user_guess = solution_params.dig(:user_guess)
    end

    def solution_params
      params.expect(solution: [ :guesser_name, :user_guess, :puzzle_id ])
    end
end
