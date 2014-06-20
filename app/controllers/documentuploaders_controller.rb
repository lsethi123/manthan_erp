class DocumentuploadersController < ApplicationController
  load_resource :only => [:show, :update, :edit, :destroy]
  def create
    @documentuploader = Documentuploader.new(documentuploader_params)
    if @documentuploader.save
      flash[:success] = I18n.t :success, :scope => [:documentuploader, :create]
      redirect_to documentuploaders_path
    else
      render "new"
    end
  end
  def show
  end
  def index
    @documentuploaders = Documentuploader.all
  end

  def new
    @documentuploader = Documentuploader.new
  end
  def edit
    @documentuploader = Documentuploader.find(params[:id])
  end
  def update
    @documentuploader = Documentuploader.find(params[:id])
    if @documentuploader.update(documentuploader_params)
      flash[:success] = I18n.t :success, :scope => [:documentuploader, :update]
      redirect_to documentuploaders_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:documentuploader, :update]
      render "edit"
    end
  end
  def destroy
    @documentuploader = Documentuploader.find(params[:id])
    if @documentuploader.destroy
      flash[:success] = I18n.t :success, :scope => [:documentuploader, :destroy]
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:documentuploader, :destroy]
    end
    redirect_to documentuploaders_path
  end
  private

  def documentuploader_params
    params.require(:documentuploader).permit(:name, :educational_certificates, :previous_employment_proof, :salary_slips_for_previous_months)
  end
end
