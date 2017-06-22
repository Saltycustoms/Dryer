class ColorsController < ApplicationController
  dried_options ({
    fields:
      [:name, :hex],
    presentation:
      [:id, :name, :hex]
  })
end
