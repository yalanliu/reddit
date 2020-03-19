class VotesController < ApplicationController
  def create
    post_id = params[:vote][:post_id]
    vote = Vote.new (vote_params)
    vote.accout_id = current_account.accout_id

    existing_vote = Vote.where(account_id: current_account.id, post_id: post_id)

    respond_to do |format|
      format.js {
        if existing_vote.size > 0
          existing_vote.first.destroy
        else
          if vote.save
            @success = true
          else
            @success = false
          end

          @post = Post.find(post_id)
          @total_upvotes = @post.total_upvotes
          @total_downvotes = @post.downvotes
        end
      }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:upvote, :post_id)
  end
end
