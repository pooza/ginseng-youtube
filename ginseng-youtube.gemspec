require 'yaml'
package = YAML.load_file(File.join(__dir__, 'config/lib.yaml'))['package']

Gem::Specification.new do |spec|
  spec.name = 'ginseng-youtube'
  spec.version = package['version']
  spec.authors = package['authors']
  spec.email = package['email']
  spec.summary = package['description']
  spec.description = package['description']
  spec.homepage = package['url']
  spec.license = package['license']
  spec.metadata['homepage_uri'] = package['url']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>=3.4'

  # ⚠⚠ **`ginseng-core` の床は 1.23.1（pooza/ginseng-style#120）。** `Service` は `http_class` の
  # HTTP で API を呼び、**API キーはクエリの `key=` に載る**。`Ginseng::HTTP` はログのマスクを
  # `config_class` から読み、core が既定の名前と設定を**合成**するようになったのは 1.23.1
  # （pooza/ginseng-core#586）。それより古い core では、利用側が名前を列挙した時点で**既定の名前が落ちる**。
  # 🔴 床が無いと `bundle` は通ってしまい、ログに資格情報が出るまで分からない。
  # ⚠ **外してよい条件は無い。** 上げるのは、core の新しい口に乗ったとき。
  # 🔴 `ginseng-core` は rubygems.org に無い。**利用側の `Gemfile` に git の参照が要る**
  # （無ければ解決できずに止まる。いまの利用側は全員書いている）。
  spec.add_dependency 'ginseng-core', '>=1.23.1'
end
