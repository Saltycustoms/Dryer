# Don't Repeat Yourself (DRY) for CRUD controllers

1. Create a **Parent** Controller that inherits from **ApplicationController**.
2. Add CRUD actions
```
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
```
self.controller_name will return name of current controller in **small letters** based on your routes.<br>
safe_constantize is a method that returns a Constant based on the string given. [More about safe_constantize](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-safe_constantize)

3. Create a **Child** Controller that inherits from the **Parent** Controller.
```
class ColorsController < ResourcesController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  def create
    @resource = resource_class.new(resource_params)
    super
  end

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
```
In your **Child** Controller, change your resource_params based on the model and permit the required parameters.<br>
Remember to change your views' instance variables to use **@resource** or **@resources**.
