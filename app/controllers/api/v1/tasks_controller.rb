module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!

      def index
        tasks = current_user.tasks
                           .unarchived
                           .order(due_at: :desc)

        render json: tasks, status: :ok
      end
    end
  end
end
