class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_bucketter, only: [:edit, :new, :update,:destroy]
  before_action :current_bucketters_book, only: [:edit, :update,:destroy]

  # GET /books
  # GET /books.json
  def index
    @q     = Book.search(params[:q])
    @books = @q.result(distinct: true)
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @books = @books.paginate(page: params[:page])

  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = current_bucketter.books.build(book_params)

    if @book.save
      flash[:success]  = "Successfully Registered"
      redirect_to @book
    else
      render 'new'
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :auther, :publisher,
                                   :version)
    end

    def current_bucketters_book
      redirect_to(root_url) unless @book.bucketter == current_bucketter
    end

end
