class TeachersController < ApplicationController
  autocomplete :teacher, :name
  
  def show
    @teacher = Teacher.find(params[:id])
  end

end
