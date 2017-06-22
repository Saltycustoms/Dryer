class ResourcesController < ApplicationController
  def index
    @resources = resource_class.all.page(params[:page]).per(50)
  end

  def new
    @resource = resource_class.new
  end

  def create
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: "#{@resource.class.name} was successfully created" }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to send("#{@resource.class.name.downcase.pluralize}_url"), notice: "#{@resource.class.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = resource_class.find_by(id: params[:id])
    end

    def resource_class
      self.controller_name.camelize.singularize.safe_constantize
    end
end
