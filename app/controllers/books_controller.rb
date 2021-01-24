class BooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @currentuser = current_user
      @books = Book.page(params[:page]).reverse_order
      render :index
    end
  end

  def index
    @book = Book.new
    @currentuser = current_user
    @books = Book.page(params[:page]).reverse_order
  end

  def show
    @book = Book.new
    @bookid = Book.find(params[:id])
    @user = @bookid.user
    @books = @user.books.page(params[:page]).reverse_order
  end

  def edit
    @book = Book.find(params[:id])
    if current_user != @book.user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :image, :body)
  end
end
