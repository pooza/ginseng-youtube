module Ginseng
  module YouTube
    class VideoURITest < Test::Unit::TestCase
      def setup
        @uri = VideoURI.parse('https://www.youtube.com/watch?v=uFfsTeExwbQ')
        @music_uri = VideoURI.parse('https://music.youtube.com/watch?v=mwJiuNq1eHY&list=RDAMVMmwJiuNq1eHY')
      end

      def test_id
        return if Environment.ci?

        assert_equal('uFfsTeExwbQ', @uri.id)
        assert_equal('mwJiuNq1eHY', @music_uri.id)
      end

      def test_data
        return if Environment.ci?

        assert_kind_of(Hash, @uri.data)
        assert_kind_of(Hash, @music_uri.data)
      end

      def test_title
        return if Environment.ci?

        assert_equal('【キラキラ☆プリキュアアラモード】後期エンディング 「シュビドゥビ☆スイーツタイム」 （歌：宮本佳那子）', @uri.title)
        assert_equal('キミに100パーセント', @music_uri.title)
      end

      def test_cnannel
        return if Environment.ci?

        assert_equal('プリキュア公式YouTubeチャンネル', @uri.channel)
        assert(['宮本佳那子 - Topic', 'Kanako Miyamoto - Topic'].member?(@music_uri.channel))
      end

      def test_artist
        return if Environment.ci?

        assert_equal('プリキュア公式YouTubeチャンネル', @uri.artist)
        assert_equal('宮本佳那子', @music_uri.artist)
      end

      def test_music?
        return false if Environment.ci?

        assert_false(@uri.music?)
        assert_predicate(@music_uri, :music?)
      end

      def test_image_uri
        return if Environment.ci?

        assert_kind_of(Ginseng::URI, @uri.image_uri)
        assert_kind_of(Ginseng::URI, @music_uri.image_uri)
      end

      def test_count
        return if Environment.ci?

        assert_predicate(@uri.count, :positive?)
        assert_predicate(@music_uri.count, :positive?)
      end
    end
  end
end
