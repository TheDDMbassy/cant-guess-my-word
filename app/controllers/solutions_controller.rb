class SolutionsController < ApplicationController
  before_action :set_solution, only: %i[ show update destroy ]
  before_action :set_user_guess, only: %i[ create update ]

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
    @solution = Solution.new(solution_params.except(:user_guess))

    respond_to do |format|
      @solution.guess(@user_guess)

      format.html { redirect_to @solution }
      format.json { render :show, status: :created, location: @solution }

    rescue AASM::InvalidTransition
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @solution.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /solutions/1 or /solutions/1.json
  def update
    respond_to do |format|
      # if @solution.may_guess?(@user_guess)
      @solution.guess(@user_guess)
      format.html { redirect_to @solution, status: :see_other }
      format.json { render :show, status: :ok, location: @solution }
      # else
    rescue AASM::InvalidTransition
      format.html { render :show, status: :unprocessable_entity }
      format.json { render json: @solution.errors, status: :unprocessable_entity }
      # end
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
      params.expect(solution: [ :status, :guesser_name, :elapsed_time, :user_guess, :puzzle_id ])
    end
end
