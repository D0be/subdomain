class ScansController < ApplicationController
  def index
    @tasks = Scan.paginate(page: params[:page], per_page: 15)
    @count = Scan.count
  end

  def new
  end

  def create
    @scan = Scan.new(scan_params)

    if @scan.save
      @scan.update(jid: SubdomainWorker.perform_async(@scan.id))
      flash[:success] = "添加成功"
      redirect_to '/scans/index'
    else
      @tasks = Scan.paginate(page: params[:page], per_page: 15)
      @count = Scan.count
      render 'index'
    end

  end

  def destroy
    @task = Scan.find(params[:id])

    if @task.finished?
      @task.destroy
    else
      SubdomainWorker.cancel!(@task.jid)
      @task.finished!
    end

    redirect_to '/scans/index'
  end

  private

  def scan_params
    params.require(:scan).permit(:title, :target)
  end

end
