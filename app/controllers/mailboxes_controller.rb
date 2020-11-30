class MailboxesController < ApplicationController
  before_action :set_mailbox, only: [:show, :edit, :update, :destroy]

  def index
    @mailboxes = Mailbox.all
  end

  def show
    @emails = @mailbox.emails
  end

  def new
    @mailbox = Mailbox.new
  end

  def create
    @mailbox = Mailbox.new(mailbox_params)
    if @mailbox.save
      flash[:success] = 'Successfully created'
      redirect_to mailbox_path(@mailbox)
    else
      flash[:error] = 'Invalid input'
      render :new
    end
  end

  def edit
  end

  def update
    if @mailbox.update(mailbox_params)
      flash[:success] = 'Successfully updated'
      redirect_to mailbox_path(@mailbox)
    else
      flash[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @mailbox.destroy
    flash[:success] = 'Successfully destroyed mailbox'
    redirect_to mailboxes_path
  end

  private

  def mailbox_params
    params.require(:mailbox).permit(:name, :sendgrid_api_token)
  end

  def set_mailbox
    @mailbox = Mailbox.find(params[:id])
  end
end
