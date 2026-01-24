class SolutionsController < ApplicationController
  before_action :set_solution, only: %i[ show edit update destroy ]

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

  # GET /solutions/1/edit
  def edit
  end

  # POST /solutions or /solutions.json
  def create
    @solution = Solution.new(transformed(solution_params))


    respond_to do |format|
      if @solution.save
        format.html { redirect_to @solution }
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solutions/1 or /solutions/1.json
  def update
    respond_to do |format|
      if @solution.update(transformed(solution_params))
        format.html { redirect_to @solution, status: :see_other }
        format.json { render :show, status: :ok, location: @solution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
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

    def transformed(solution_params)
      guess = solution_params[:guess]

      solution_params.except(:guess).merge({
        # Add the latest guess to the entire string of guesses
        guesses: "#{@solution&.guesses} #{guess}".strip,
        most_recent_guess: guess
      })
    end

    def set_solution
      @solution = Solution.find(params.expect(:id))
    end

    def solution_params
      params.expect(solution: [ :status, :guesser_name, :elapsed_time, :guess, :puzzle_id ])
    end
end
