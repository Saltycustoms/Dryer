# Don't Repeat Yourself (DRY) for CRUD controllers

1. Create a Concern Module.
```ruby
module Dryer
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :resource_fields, :presentation_fields, :namespace

    def dried_options(options = {})
      @resource_fields = options[:fields]
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
```
self.controller_name will return name of current controller in **small letters** based on your routes.<br>
safe_constantize is a method that returns a Constant based on the string given. [More about safe_constantize](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-safe_constantize)

2. Include the Module in **ApplicationController**.
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Dryer
end
```

3. In your normal Controllers, add the permitted form parameters in fields array.
```ruby
class BlanksController < ApplicationController
  dried_options ({
    fields:
      [:name, :brand, sides_attributes: [:id, :name, :attachment, :attachment_data, :_destroy]],
    presentation:
      [:id, :name, :brand],
    namespace: :admin
  })
end
```
Add any presentation fields to be used in index views if any.<br>
Add namespace if any.

4. In your index views.
```ruby
<%= render
    "shared/crude/index",
    resources: @resources,
    resource_name: "Color",
    resource_fields: controller.class.presentation_fields
%>
```
Remember to change your views' instance variables to use **@resource** or **@resources**.
