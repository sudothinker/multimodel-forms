class ArticlesController < ApplicationController
  # GET /article
  # GET /article.xml
  def index
    @articles = Article.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @articles.to_xml }
    end
  end

  # GET /article/1
  # GET /article/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @article.to_xml }
    end
  end

  # GET /article/new
  def new
    @article = Article.new
  end

  # GET /article/1;edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /article
  # POST /article.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to article_url(@article) }
        format.xml  { head :created, :location => article_url(@article) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors.to_xml }
      end
    end
  end

  # PUT /article/1
  # PUT /article/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to article_url(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors.to_xml }
      end
    end
  end

  # DELETE /article/1
  # DELETE /article/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.xml  { head :ok }
    end
  end
end
