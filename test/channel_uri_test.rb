module Ginseng
  module YouTube
    class ChannelURITest < Test::Unit::TestCase
      def setup
        @uri = ChannelURI.parse('https://www.youtube.com/channel/UCSsjL41NsyqSNNbanuI0htg')
      end

      def test_id
        assert_equal('UCSsjL41NsyqSNNbanuI0htg', @uri.id)
      end

      def test_id=
        @uri.id = 'hogefuga'

        assert_equal('hogefuga', @uri.id)
      end

      def test_data
        assert_kind_of(Hash, @uri.data)
      end

      def test_title
        assert_equal('プリキュア公式YouTubeチャンネル', @uri.title)
      end
    end
  end
end
