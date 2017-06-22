class ColorsController < ResourcesController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  # POST /colors
  # POST /colors.json
  def create
    @resource = resource_class.new(resource_params)
    super
  end

  # PATCH/PUT /colors/1
  # PATCH/PUT /colors/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: "#{@resource.class.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:color).permit(:name, :hex)
    end
end
