module Dryer
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :resource_fields, :presentation_fields, :namespace

    def dried_options(options = {}) # Alternatively `options = {}`
      @resource_fields = options[:fields]       # Alternatively `options[:except] || []`
      @presentation_fields = options[:presentation]
      @namespace = options[:namespace] || nil
    end
  end

  included do
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
  end


  def index
    @resources = resource_class.all.page(params[:page]).per(50)
  end

  def new
    @resource = resource_class.new
  end

  def create
    @resource = resource_class.new(resource_params)
    respond_to do |format|
      if @resource.save
        format.html { redirect_to [self.class.namespace, @resource], notice: "#{@resource.class.name} was successfully created" }
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

  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to [self.class.namespace, @resource], notice: "#{@resource.class.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to [self.class.namespace, @resource.class.name.underscore.pluralize], notice: "#{@resource.class.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def resource_class
    self.controller_name.camelize.singularize.safe_constantize
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = resource_class.find_by(id: params[:id])
    end

    def resource_params
      params.require(resource_class.name.underscore.to_sym).permit(self.class.resource_fields)
    end

end
