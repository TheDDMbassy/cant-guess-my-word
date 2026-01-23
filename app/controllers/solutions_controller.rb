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
    @solution = Solution.new
  end

  # GET /solutions/1/edit
  def edit
  end

  # POST /solutions or /solutions.json
  def create
    @solution = Solution.new(solution_params)

    respond_to do |format|
      if @solution.save
        format.html { redirect_to @solution, notice: "Solution was successfully created." }
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
      if @solution.update(solution_params)
        format.html { redirect_to @solution, notice: "Solution was successfully updated.", status: :see_other }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def solution_params
      params.expect(solution: [ :status, :guesser_name, :elapsed_time, :guesses, :puzzle_id ])
    end
end
