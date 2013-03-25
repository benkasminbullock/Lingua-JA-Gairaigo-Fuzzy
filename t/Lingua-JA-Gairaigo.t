# This is a test for module Lingua::JA::Gairaigo.

use warnings;
use strict;
use Test::More;
use Lingua::JA::Gairaigo 'same_gairaigo';
use utf8;

# Test with hei versus he- (chouon).

ok (same_gairaigo ('ヘイホ', 'ヘーホ'));
ok (same_gairaigo ('メインフレーム', 'メーンフレーム'));

# Test for a false positive.

ok (! same_gairaigo ('メインフレーム', 'フレームメーン'));

# Test with sokuon versus chouon.

ok (same_gairaigo ('ガーベッジコレクション', 'ガベジコレクション'));
ok (same_gairaigo ('ガーベッジコレクション', 'ガーベジコレクション'));

# Test with dot/no dot.

ok (same_gairaigo ('ジャーマン・シェパード', 'ジャーマンシェパード'));

# Test with chouon/no chouon

ok (same_gairaigo ('ローンダリング', 'ロンダリング');

done_testing ();

# Local variables:
# mode: perl
# End:
