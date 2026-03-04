// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'MeowTalk';

  @override
  String get tabSounds => 'サウンド';

  @override
  String get tabTest => '性格診断';

  @override
  String get tabHealth => '健康';

  @override
  String get tabGames => 'ゲーム';

  @override
  String get tabMore => 'その他';

  @override
  String get soundsPageTitle => '猫語コミュニケーション';

  @override
  String get soundsTitle => '猫の鳴き声シミュレーター';

  @override
  String get soundCategoryCalling => '呼びかけ';

  @override
  String get soundCategoryEmotion => '感情';

  @override
  String get soundCategoryEnvironment => '音楽';

  @override
  String get soundsSubtitleEmotion => '猫の気持ちを伝えるサウンド';

  @override
  String get soundsSubtitleCalling => '呼びかけ・誘導サウンド';

  @override
  String get soundsSubtitleEnvironment => '定番 + 新規6種類の音楽';

  @override
  String get soundLooping => 'ループ再生中';

  @override
  String get soundPlaceholderTag => '準備中';

  @override
  String get soundPlaceholderHint => 'この音源はプレースホルダーです。音声と画像は後で追加してください。';

  @override
  String get soundNamePurr => 'ゴロゴロエンジン';

  @override
  String get soundNameMeow => '甘え鳴きモード';

  @override
  String get soundNameHiss => 'シャー警告';

  @override
  String get soundNameChattering => 'ごきげんチャッター';

  @override
  String get soundNameHungry => 'ごはん催促';

  @override
  String get soundNameWhimper => 'なでてコール';

  @override
  String get soundNameCanOpener => '缶オープナー音';

  @override
  String get soundNameFoodShaking => 'カリカリ袋シャカシャカ';

  @override
  String get soundNameWater => '給水器サウンド';

  @override
  String get soundNameWhiteNoise => 'おやすみホワイトノイズ';

  @override
  String get soundNameBell => 'ベル音';

  @override
  String get soundNameSqueakyToy => '鈴入りおもちゃ';

  @override
  String get soundNameMouseSounds => 'ネズミの気配';

  @override
  String get soundNamePlasticBag => 'おやつ袋のカサカサ';

  @override
  String get soundNameBirdSounds => '鳥のさえずり';

  @override
  String get soundNameCanOpen => '缶を開ける音';

  @override
  String get soundNameComeback => 'おかえりコール';

  @override
  String get soundNameSqueakyToys => 'カシャカシャおもちゃ';

  @override
  String get soundNameAmbientWhiteNoise => 'ホワイトノイズ';

  @override
  String get soundNameAmbientWater => '流水音';

  @override
  String get soundNameAmbientBirdSounds => 'やさしい鳥の声';

  @override
  String get soundNameAmbientFeather => '羽のサラサラ音';

  @override
  String get soundNameAmbientMouseSounds => '遠くのネズミ音';

  @override
  String get soundNameMusicCatSpecific => 'リラックス音楽';

  @override
  String get soundNameMusicSlowClassical => 'ゆったりピアノ';

  @override
  String get soundNameMusicNoiseBlend => 'ノイズブレンド';

  @override
  String get soundNameMusicNatureAmbience => '雨の環境音';

  @override
  String get soundNameMusicAmbientDrone => 'せせらぎアンビエント';

  @override
  String get soundNameMusicSoftInteraction => 'カフェアンビエンス';

  @override
  String get testTitle => '16ニャン格診断';

  @override
  String get testSubtitle => 'うちの子の隠れた性格をチェック';

  @override
  String get testBasicMode => 'ベーシック（12問）';

  @override
  String get testAdvancedMode => 'アドバンス（24問）';

  @override
  String get testBasicModeDesc => '猫の基本的な傾向を手早く把握';

  @override
  String get testAdvancedModeDesc => 'より詳しく分析し、二面性も見つける';

  @override
  String get testTheoryDesc => 'MBTI理論をもとに、日常の行動観察から\n猫の個性を読み解きます';

  @override
  String get testTip => '正解・不正解はありません。普段の様子に近い方を選んでください。';

  @override
  String testQuestionCount(int count) {
    return '$count問';
  }

  @override
  String get testAnalyzing => '性格を分析中…';

  @override
  String testProgressLabel(int current, int total) {
    return '第$current問 / 全$total問';
  }

  @override
  String get analyzingTitle => '分析中…';

  @override
  String get analyzingStep1 => '行動パターンを分析中…';

  @override
  String get analyzingStep2 => '性格軸を特定中…';

  @override
  String get analyzingStep3 => '一致度を計算中…';

  @override
  String get analyzingStep4 => 'レポートを生成中…';

  @override
  String get testResultTitle => '診断結果';

  @override
  String get testResultDualPersonality => '二面性の傾向があります';

  @override
  String get testResultDimAnalysis => '軸ごとの分析';

  @override
  String get testResultDescription => '性格の説明';

  @override
  String get testResultAdvice => 'お世話のアドバイス';

  @override
  String get testResultRetake => 'もう一度診断';

  @override
  String get testResultPoster => 'ポスター作成';

  @override
  String get testResultSaveFailed =>
      '結果は表示されましたが、猫プロフィールへの保存に失敗しました。後ほど再試行してください。';

  @override
  String get testCurrentResultTitle => '現在のプロフィール結果';

  @override
  String get testViewFullReport => '詳細レポートを見る';

  @override
  String get testNoResultYet => 'この猫の性格診断結果はまだありません。先に診断を完了してください。';

  @override
  String get testStartNow => '今すぐ診断を開始';

  @override
  String testLastTestedAt(String time) {
    return '最終診断：$time';
  }

  @override
  String personalityRecommendationSubtitle(String code, String title) {
    return '$code・$title に合わせて表示順を調整済み';
  }

  @override
  String get personalityRecommendedBadge => 'おすすめ';

  @override
  String get healthDashboardTitle => '猫の健康';

  @override
  String get healthTitle => '健康記録';

  @override
  String get healthPreparing => '準備中…';

  @override
  String get healthTodayRecords => '記録タイムライン';

  @override
  String get healthSwitchCat => '猫を切り替え';

  @override
  String healthPersonalityTipTitle(String code) {
    return '性格ケアのヒント（$code）';
  }

  @override
  String get healthWeightOutOfGoalWarning =>
      '体重が目標範囲を外れています。しばらく体重測定と食事観察の頻度を上げましょう。';

  @override
  String get healthWeight => '体重';

  @override
  String get healthWater => '飲水';

  @override
  String get healthDiet => '食事';

  @override
  String get healthExcretion => '排泄';

  @override
  String get healthNoChange => '変化なし';

  @override
  String healthWaterTarget(String target) {
    return '目標 ${target}ml';
  }

  @override
  String get healthDietDone => '達成';

  @override
  String get healthDietInProgress => '進行中';

  @override
  String healthDietMealsUnit(int count) {
    return '/$count回';
  }

  @override
  String healthTimelineWeight(String value) {
    return '体重 ${value}kg';
  }

  @override
  String healthTimelineDiet(String value) {
    return '食事 ${value}g';
  }

  @override
  String healthTimelineWater(String value) {
    return '飲水 ${value}ml';
  }

  @override
  String get healthTimelinePoop => '排便';

  @override
  String get healthTimelineUrine => '排尿';

  @override
  String get healthTimelineEmpty => 'まだ健康記録がありません\n右下の + をタップして記録を始めましょう';

  @override
  String get healthTimelineDeleteTitle => '削除の確認';

  @override
  String get healthTimelineDeleteContent => 'この記録を削除しますか？';

  @override
  String healthWeightGoalRange(String min, String max) {
    return '目標 $min-${max}kg';
  }

  @override
  String healthWeightGoalMin(String min) {
    return '目標 >= ${min}kg';
  }

  @override
  String healthWeightGoalMax(String max) {
    return '目標 <= ${max}kg';
  }

  @override
  String get healthWeightExceeded => '（現在オーバー）';

  @override
  String healthWeightAlert(String percent) {
    return '過去30日で体重が $percent% 以上変化しています';
  }

  @override
  String get weightSheetTitle => '⚖️ 体重記録';

  @override
  String weightLastRecord(String weight, String date) {
    return '前回：${weight}kg（$date）';
  }

  @override
  String get weightLastRecordToday => '今日';

  @override
  String weightDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String get weightMoodLabel => '計測時の協力度';

  @override
  String get weightMoodCooperative => '協力的';

  @override
  String get weightMoodNeutral => '普通';

  @override
  String get weightMoodResistant => '嫌がる';

  @override
  String get weightOutOfGoalTitle => '目標範囲外です';

  @override
  String weightOutOfGoalContent(String weight) {
    return '現在の体重 ${weight}kg は目標範囲外です。保存を続けますか？';
  }

  @override
  String get weightContinueSave => 'このまま保存';

  @override
  String weightGoalRange(String min, String max) {
    return '目標範囲 $min - $max kg';
  }

  @override
  String weightGoalMinLimit(String min) {
    return '目標下限 $min kg';
  }

  @override
  String weightGoalMaxLimit(String max) {
    return '目標上限 $max kg';
  }

  @override
  String get weightGoalExceeded => '（現在オーバー）';

  @override
  String get dietSheetTitle => '🍚 食事記録';

  @override
  String dietTodayMeals(int current, int target) {
    return '本日の給餌：$current/$target 回（保存後）';
  }

  @override
  String get dietBrandSection => 'ブランド/種類';

  @override
  String get dietFoodTypeSection => 'フードタイプ';

  @override
  String get dietBrandOrijen => 'オリジン';

  @override
  String get dietBrandZiwi => 'ジウィ';

  @override
  String get dietBrandRoyalCanin => 'ロイヤルカナン';

  @override
  String get dietBrandHomemade => '手作り';

  @override
  String get dietBrandTreats => 'おやつ';

  @override
  String get dietBrandOther => 'その他';

  @override
  String get dietFoodTypeStaple => '主食';

  @override
  String get dietFoodTypeCanned => 'ウェットフード';

  @override
  String get dietFoodTypeTreats => 'おやつ';

  @override
  String get dietFoodTypeFreezeDried => 'フリーズドライ';

  @override
  String get dietAmountSection => '摂取量 (g)';

  @override
  String get dietSameAsLast => '前回記録と同じ';

  @override
  String get dietTapToChangeTime => 'タップして時間を変更';

  @override
  String dietConfirmLargeAmount(String amount) {
    return '入力値が大きめです（${amount}g）。このまま保存しますか？';
  }

  @override
  String get waterSheetTitle => '💧 飲水記録';

  @override
  String get waterQuickSmall => '少量';

  @override
  String get waterQuickHalf => '半分';

  @override
  String get waterQuickOne => '1杯';

  @override
  String get waterQuickFull => '満杯';

  @override
  String waterTodayTarget(String current, String target) {
    return '本日の目標：$current/${target}ml';
  }

  @override
  String get excretionSheetTitle => '🐾 排泄記録';

  @override
  String get excretionTabPoop => '便 💩';

  @override
  String get excretionTabUrine => '尿 💧';

  @override
  String get excretionPoop1Name => 'コロコロ硬便';

  @override
  String get excretionPoop1Desc => 'やや硬め。飲水量を増やしましょう';

  @override
  String get excretionPoop2Name => '理想的な便';

  @override
  String get excretionPoop2Desc => '健康的な状態です';

  @override
  String get excretionPoop3Name => 'やわらか便';

  @override
  String get excretionPoop3Desc => '消化が少し不安定です';

  @override
  String get excretionPoop4Name => '水様便';

  @override
  String get excretionPoop4Desc => '受診を検討してください';

  @override
  String get excretionUrineSmall => '少なめ';

  @override
  String get excretionUrineMedium => '標準';

  @override
  String get excretionUrineLarge => '多め';

  @override
  String get excretionAnomaly => '異常あり（血液/異物）';

  @override
  String get gamesTitle => 'インタラクティブゲーム';

  @override
  String get gamesPageTitle => 'ゲームで遊ぼう';

  @override
  String get gameLaser => 'レーザードット';

  @override
  String get gameShadowPeek => 'かくれんぼシャドウ';

  @override
  String get gameMouseHunt => 'ネズミハント';

  @override
  String get gameRainbow => 'レインボーチェイス';

  @override
  String get gameLaserSubtitle => '定番の赤点追いかけ';

  @override
  String get gameShadowPeekSubtitle => '草むらや箱からひょっこり';

  @override
  String get gameCatchMouseSubtitle => '動き回るネズミや魚をタップして捕まえる';

  @override
  String get gameRainbowSubtitle => '光の軌跡が猫の足元に寄ってくる';

  @override
  String get gameLaserDescription =>
      '画面上を動くレーザーポインターを再現し、猫の追いかけ欲を引き出します。暗い背景の上を光点が滑るように動き、ときどき加速・停止します。';

  @override
  String get gameShadowPeekDescription =>
      '草むらや段ボール箱から小さな生き物が時々顔を出します。逃げる前にすばやくタップして見つけましょう。';

  @override
  String get gameCatchMouseDescription =>
      'リアルなネズミや魚が画面内を動き回ります。タップで捕まえると効果音とパーティクル演出が入り、少しして次のターゲットが出現します。';

  @override
  String get gameRainbowDescription =>
      '流れる虹のリボンがタッチに反応し、猫の足元に引き寄せられます。きらめきや波紋で楽しく遊べます。';

  @override
  String get gameDifficultyEasy => 'かんたん';

  @override
  String get gameDifficultyMedium => 'ふつう';

  @override
  String get gameDifficultyHard => 'むずかしい';

  @override
  String get gameLaserTips => 'スマホを床に平置きして、猫に自由に追いかけさせてください。';

  @override
  String get gameShadowPeekTips => '草むらや箱をタップして、隠れた生き物を見つけましょう。';

  @override
  String get gameCatchMouseTips => 'ネズミや魚をタップしてポイント獲得。';

  @override
  String get gameRainbowTips => '画面タップで虹を近づけられます。';

  @override
  String get gameScoreUnit => '回';

  @override
  String get gameRainbowTouchUnit => 'タップ';

  @override
  String get gameRainbowHint => '画面をタップして虹を引き寄せよう';

  @override
  String get gameShadowPeekHint => '草むらと箱をよく観察して…';

  @override
  String get gameHoleAmbush => 'モグラ待ち伏せ';

  @override
  String get gameFeatherWand => '猫じゃらし';

  @override
  String get gameHoleAmbushSubtitle => '穴から飛び出す奇襲';

  @override
  String get gameFeatherWandSubtitle => '羽を振って注意を引く';

  @override
  String get gameHoleAmbushDescription => '獲物が穴からランダムに顔を出します。引っ込む前に捕まえましょう！';

  @override
  String get gameFeatherWandDescription => '画面上を動く猫じゃらしの羽をタップして捕まえよう！';

  @override
  String get gameHoleAmbushTips => '穴をよく見て、素早くタップ！';

  @override
  String get gameHoleAmbushHint => '穴を見張って、出てきたらすぐタップ';

  @override
  String get gameFeatherWandTips => '羽の動きに合わせて狙おう！';

  @override
  String get gameFeatherWandHint => 'スワイプまたはタップで猫じゃらし遊び';

  @override
  String get gameFeatherWandHit => 'キャッチ！';

  @override
  String gameRewardCapturedGoal(String rewardMl) {
    return 'キャッチ！ +${rewardMl}ml の補水提案。本日の目標達成です';
  }

  @override
  String gameRewardCapturedProgress(
    String rewardMl,
    int capturesToday,
    int captureGoal,
  ) {
    return 'キャッチ！ +${rewardMl}ml の補水提案（$capturesToday/$captureGoal）';
  }

  @override
  String gameRewardSessionEnd(int capturesToday, int captureGoal) {
    return 'この回は終了。本日の達成：$capturesToday/$captureGoal';
  }

  @override
  String get gameRewardCapturedNoCat => 'キャッチ！次の回まで少し休憩しましょう';

  @override
  String get gameRewardSessionEndNoCat => 'この回は終了。猫を少し休ませてください';

  @override
  String gameFinalTargetBanner(int seconds) {
    return 'ラストボーナス：最後のターゲットを捕まえよう（${seconds}s）';
  }

  @override
  String get gameExitHint => '四隅を3秒長押しで終了';

  @override
  String get moreTitle => 'その他';

  @override
  String get moreCatProfile => '猫プロフィール';

  @override
  String get moreCatProfileSubtitle => '猫の情報を管理';

  @override
  String get moreSettings => '設定';

  @override
  String get moreSettingsSubtitle => 'アプリ設定';

  @override
  String get moreAbout => 'このアプリについて';

  @override
  String get moreAboutSubtitle => 'バージョン情報とフィードバック';

  @override
  String get moreTheater => 'キャットシアター';

  @override
  String get theaterSubtitle => '厳選した猫動画コンテンツ';

  @override
  String get moreAI => 'AI認識';

  @override
  String get settingsPageTitle => '設定';

  @override
  String get settingsGameSection => 'ゲーム設定';

  @override
  String gameSettingsTitle(String gameName) {
    return '$gameNameの設定';
  }

  @override
  String get gameSettingsSpeedFrequency => '出現頻度';

  @override
  String get gameSettingsSpeedMovement => '移動速度';

  @override
  String get gameSettingsSound => '効果音';

  @override
  String get gameSettingsSoundDesc => 'プレイ中に効果音を再生';

  @override
  String get gameSettingsVibration => '触覚フィードバック';

  @override
  String get gameSettingsVibrationDesc => 'ターゲットに触れた時に振動';

  @override
  String get gameSettingsDescription => '遊び方';

  @override
  String get gameSettingsStart => 'ゲーム開始';

  @override
  String get posterTitle => 'うちの猫の性格レポート';

  @override
  String get posterSave => 'アルバムに保存';

  @override
  String get posterSaveComingSoon => '保存機能は近日公開予定です…';

  @override
  String get posterShare => '友だちにシェア';

  @override
  String get posterShareComingSoon => 'シェア機能は近日公開予定です…';

  @override
  String get posterFooter => '猫語 · 16ニャン格診断';

  @override
  String get settingsLanguageSection => '言語';

  @override
  String get settingsLanguageDesc => 'アプリの表示言語を選択';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageSystem => 'システムに従う';

  @override
  String get aboutPageTitle => 'このアプリについて';

  @override
  String get aboutAppName => 'ニャートーク';

  @override
  String get aboutFeedbackEmail => 'お問い合わせメール';

  @override
  String get aboutPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get aboutPrivacyPolicySubtitle => 'タップしてプライバシーポリシーを表示';

  @override
  String get aboutCannotOpenLink => 'リンクを開けませんでした';

  @override
  String aboutVersionLabel(String version, String build) {
    return 'バージョン $version（$build）';
  }

  @override
  String aboutCopyright(String year) {
    return '© $year MeowTalk. 無断転載を禁じます。';
  }

  @override
  String get splashTagline => 'にゃ〜';

  @override
  String get splashAppName => 'ニャートーク';

  @override
  String get splashSlogan => '猫を理解し、猫の気持ちを聞こう';

  @override
  String get catProfileTitle => '猫プロフィール';

  @override
  String get catProfileEmpty => '猫がまだ登録されていません';

  @override
  String get catProfileAddFirst => '右下の + ボタンから最初の猫を追加しましょう';

  @override
  String get catProfileManage => '猫プロフィールを管理';

  @override
  String get catAdded => '猫プロフィールを追加しました';

  @override
  String get catUpdated => '猫プロフィールを更新しました';

  @override
  String get catDeleted => '猫プロフィールを削除しました';

  @override
  String get catMinimumOne => '猫プロフィールは最低1件必要です';

  @override
  String get catCannotDeleteTitle => '削除できません';

  @override
  String get catCannotDeleteContent => 'この猫には健康記録があります。先に関連記録を整理してください。';

  @override
  String get catGotIt => '了解';

  @override
  String get catDeleteTitle => '猫プロフィールを削除';

  @override
  String catDeleteConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String catSwitched(String name) {
    return '$name に切り替えました';
  }

  @override
  String catLoadFailed(String error) {
    return '読み込み失敗：$error';
  }

  @override
  String get catAddButton => '猫を追加';

  @override
  String get catCurrentBadge => '現在';

  @override
  String get catNoBreed => '品種未設定';

  @override
  String get catUnknownAge => '年齢不明';

  @override
  String catAgeMonths(int months) {
    return '$monthsか月';
  }

  @override
  String catAgeYears(int years) {
    return '$years歳';
  }

  @override
  String catAgeYearsMonths(int years, int months) {
    return '$years歳 $monthsか月';
  }

  @override
  String get catSexMale => 'オス';

  @override
  String get catSexFemale => 'メス';

  @override
  String get catSexUnknown => '性別不明';

  @override
  String get catNeutered => '去勢/避妊済み';

  @override
  String get catNotNeutered => '未去勢/未避妊';

  @override
  String catWeightGoalRange(String min, String max) {
    return '体重目標 $min-$max kg';
  }

  @override
  String catWeightGoalMin(String min) {
    return '体重目標 ≥ $min kg';
  }

  @override
  String catWeightGoalMax(String max) {
    return '体重目標 ≤ $max kg';
  }

  @override
  String catDailyTargets(String water, int meals) {
    return '目標飲水量 $water ml/日 · 目標給餌回数 $meals 回/日';
  }

  @override
  String get catLoadingTrend => '健康トレンドを読み込み中…';

  @override
  String catTrend7DaysWater(String amount) {
    return '直近7日の平均飲水量 ${amount}ml';
  }

  @override
  String catTrendMeals(int count) {
    return '給餌 $count 回';
  }

  @override
  String get catPersonalitySection => '性格プロフィール';

  @override
  String get catPersonalityUnknown => 'まだ性格診断をしていません';

  @override
  String catPersonalityKnown(String code, String title) {
    return '$code · $title';
  }

  @override
  String catPersonalityTestedAt(String time) {
    return '診断日時 $time';
  }

  @override
  String get catPersonalityGoTest => '診断する';

  @override
  String get catPersonalityViewReport => 'レポートを見る';

  @override
  String get catTrendWeightNoData => '体重：データなし';

  @override
  String catTrendWeightChange(String change) {
    return '体重 ${change}kg';
  }

  @override
  String get catFormBasicInfo => '基本情報';

  @override
  String get catFormName => '猫の名前 *';

  @override
  String get catFormNameHint => '猫の名前を入力';

  @override
  String get catFormNameRequired => '猫の名前を入力してください';

  @override
  String get catFormBreed => '品種';

  @override
  String get catFormBreedHint => '例：ブリティッシュショートヘア';

  @override
  String get catFormSex => '性別';

  @override
  String get catFormSexUnknown => '不明';

  @override
  String get catFormSexMale => 'オス';

  @override
  String get catFormSexFemale => 'メス';

  @override
  String get catFormBirthDate => '誕生日';

  @override
  String get catFormBirthDateNotSet => '未設定';

  @override
  String get catFormNeutered => '去勢/避妊済み';

  @override
  String get catFormHealthGoals => '健康目標';

  @override
  String get catFormWeightMin => '体重目標下限 (kg)';

  @override
  String get catFormWeightMinHint => '例：3.5';

  @override
  String get catFormWeightMax => '体重目標上限 (kg)';

  @override
  String get catFormWeightMaxHint => '例：5.0';

  @override
  String get catFormWaterTarget => '1日の飲水目標 (ml)';

  @override
  String get catFormWaterHint => '例：200';

  @override
  String get catFormMealsTarget => '1日の給餌目標 (回)';

  @override
  String get catFormMealsHint => '例：3';

  @override
  String get catFormSave => '変更を保存';

  @override
  String get catFormCreate => 'プロフィールを作成';

  @override
  String get catFormEditTitle => '猫プロフィールを編集';

  @override
  String get catFormNewTitle => '新しい猫プロフィール';

  @override
  String get catFormInvalidWater => '有効な飲水目標を入力してください';

  @override
  String get catFormInvalidMeals => '有効な給餌回数を入力してください（1-20）';

  @override
  String get catFormInvalidWeight => '有効な体重目標を入力してください（kg）';

  @override
  String get catFormWeightRangeError => '体重目標の下限は上限を超えられません';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonDelete => '削除';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonEdit => '編集';

  @override
  String get commonNoCat => '先に猫を追加してください';

  @override
  String commonSaveFailed(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get commonTip => 'お知らせ';

  @override
  String get commonOk => 'OK';
}
