module Ginseng
  module YouTube
    class ServiceTest < Test::Unit::TestCase
      def setup
        @service = Service.new
      end

      def test_lookup_video
        return if Environment.ci?
        video = @service.lookup_video('uFfsTeExwbQ')

        assert_kind_of(Hash, video)
        assert_predicate(video, :present?)
        assert_equal('【キラキラ☆プリキュアアラモード】後期エンディング 「シュビドゥビ☆スイーツタイム」 （歌：宮本佳那子）', video['snippet']['title'])
      end
    end
  end
end
