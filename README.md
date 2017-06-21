# Don't Repeat Yourself (DRY) for CRUD controllers

1. Create a *Parent* Controller that inherits from **ApplicationController**.
2. Add CRUD actions
```
class Api::V1::ApiV1Controller < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  def index
    @resources = resource_class.send(:all)
    render json: @resources
  end

  def show
    render json: @resource || {}
  end

  private
    def set_resource
      @resource = resource_class.send(:find_by, id: params[:id])
    end

    def resource_class
      self.controller_name.camelize.singularize.safe_constantize
    end
end
```
self.controller_name will return name of current controller in **small letters** based on your routes.<br>
safe_constantize is a method that returns a Constant based on the string given. [More about safe_constantize](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-safe_constantize)

3. Create a *Child* Controller that inherits from the **Parent** Controller.
```
class Api::V1::BlanksController < Api::V1::ApiV1Controller
end
```

4. Every other controller that inherits from **Parent** Controller will now have CRUD actions, making your code clean.
