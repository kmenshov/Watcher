class ResYieldsController < ApplicationController
  def index
    @res_yields = ResYield.all
  end

  def show
    #"read" = true
  end

#does rewatch (update) for all recipes
  def rewatch
  end
end
