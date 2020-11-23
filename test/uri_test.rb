module Ginseng
  module YouTube
    class URITest < Test::Unit::TestCase
      def setup
        @uri = URI.parse('https://www.youtube.com/watch?v=uFfsTeExwbQ')
        @music_uri = URI.parse('https://music.youtube.com/watch?v=mwJiuNq1eHY&list=RDAMVMmwJiuNq1eHY')
      end

      def test_id
        return if Environment.ci?
        assert_equal(@uri.id, 'uFfsTeExwbQ')
        assert_equal(@music_uri.id, 'mwJiuNq1eHY')
      end

      def test_data
        return if Environment.ci?
        assert_kind_of(Hash, @uri.data)
        assert_kind_of(Hash, @music_uri.data)
      end

      def test_title
        return if Environment.ci?
        assert_equal(@uri.title, '【キラキラ☆プリキュアアラモード】後期エンディング 「シュビドゥビ☆スイーツタイム」 （歌：宮本佳那子）')
        assert_equal(@music_uri.title, 'キミに100パーセント')
      end

      def test_cnannel
        return if Environment.ci?
        assert_equal(@uri.channel, 'プリキュア公式YouTubeチャンネル')
        assert_equal(@music_uri.channel, '宮本佳那子 - Topic')
      end

      def test_artist
        return if Environment.ci?
        assert_equal(@uri.artist, 'プリキュア公式YouTubeチャンネル')
        assert_equal(@music_uri.artist, '宮本佳那子')
      end

      def test_music?
        return if Environment.ci?
        assert_false(@uri.music?)
        assert(@music_uri.music?)
      end

      def test_image_uri
        return if Environment.ci?
        assert_kind_of(Ginseng::URI, @uri.image_uri)
        assert_kind_of(Ginseng::URI, @music_uri.image_uri)
      end

      def test_count
        return if Environment.ci?
        assert(@uri.count.positive?)
        assert(@music_uri.count.positive?)
      end
    end
  end
end
