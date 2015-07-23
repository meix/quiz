# -*- encoding : utf-8 -*-

module Quiz
  module V1
    class TrainScoreWrapper < BaseWrapper
      class << self

        def user_score_info(score)
          {
            id: score.user.id,
            nick_name: score.user.nick_name,
            avatar: score.user.avatar,
            right_times: score.right_times,
            ratio: score.ratio,
            diamond: score.diamond
          }
        end

        def rake_info(records)
          ret = {user_score:{}, top_10:[]}
          if records[:user_score].present?
            score = records[:user_score]
            ret[:user_score][:id] = score.user.id
            ret[:user_score][:nick_name] = score.user.nick_name
            ret[:user_score][:avatar] = score.user.avatar
            ret[:user_score][:ranking] = records[:ranking]
            ret[:user_score][:right_times] =score.right_times
            ret[:user_score][:ratio] = score.ratio
            ret[:user_score][:diamond] = score.diamond
          end
          records[:train_scores].each_with_index do |score,index|
           ret[:top_10] << {id: score.user.id, nick_name: score.user.nick_name, avatar: score.user.avatar,
              ranking: index + 1, right_times: score.right_times, ratio: score.ratio, diamond: score.diamond}
          end
          ret
        end

      end
    end
  end
end