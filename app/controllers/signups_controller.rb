class SignupsController < ApplicationController
  before_action :set_signup, only: %i[ show edit update destroy ]

  # GET /signups or /signups.json
  def index
    @signups = Signup.all
  end

  # GET /signups/1 or /signups/1.json
  def show
  end

  # GET /signups/new
  def new
    @signup = Signup.new
  end

  # GET /signups/1/edit
  def edit
  end

  ###
  # using the web form, we will be posting an initial signup and then editing it.
  # we still want to be able to take in complete signups in case there are alt
  # entry points (e.g. passed in from admin/third party) and we don't jump
  # stright to user creation for some reason or another.
  #
  # partial signups maybe more of a headache: discerning step if someone posts
  # steps 1-3 at once. build on #ready_for_next_step?
  ###

  # POST /signups or /signups.json
  def create
    @signup = Signup.new(signup_params)

    respond_to do |format|
      if @signup.save
        @signup.increment_signup_step
        format.html { redirect_to edit_signup_path(@signup), notice: "Signup was successfully created." }
        # format.json { render :show, status: :created, location: @signup }
      else
        format.html { render :new, status: :unprocessable_entity }
        # format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  ###
  # quick step manip is going to be done with some conditional rendering and
  # posting updates with different commits: update goes forward, back goes back,
  # confirm is only on the summary page and is the one that redirects out.
  # with all the time in the world a nice shiny state machine that keeps its
  # business outside of the controller would be nice.
  #
  # it will reject invalid transitions (multiple steps at once)
  ####

  # PATCH/PUT /signups/1 or /signups/1.json
  def update
    respond_to do |format|
      if @signup.update(signup_params)
        if params[:commit] == "Next"
          @signup.increment_signup_step unless @signup.last_step?
          format.html { redirect_to edit_signup_path(@signup), notice: "Signup was successfully updated.", status: :see_other }
          # format.json { render :show, status: :ok, location: @signup }
        elsif params[:commit] == "Go Back"
          @signup.decrement_signup_step unless @signup.first_step?
          format.html { redirect_to edit_signup_path(@signup), notice: "Signup was successfully updated.", status: :see_other }
          # format.json { render :show, status: :ok, location: @signup }
        elsif params[:commit] == "Confirm"
          format.html { redirect_to @signup, notice: "Signup was successfully updated.", status: :see_other }
          # format.json { render :show, status: :ok, location: @signup }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        # format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signups/1 or /signups/1.json
  def destroy
    @signup.destroy!

    respond_to do |format|
      format.html { redirect_to signups_path, notice: "Signup was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signup
      @signup = Signup.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def signup_params
      params.expect(signup: [ :email, :address, :name, :comms_preference ])
    end
end
