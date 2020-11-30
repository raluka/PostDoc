class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :body_preview]

  def show
  end

  def body_preview
    render(layout: false)
  end

  def set_email
    @email = Email.find(params[:id])
  end
end
