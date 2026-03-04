import '../models/question.dart';

class QuestionRepository {
  static const List<Question> _basicZhQuestions = [
    Question(
      number: 1,
      dimension: Dimension.EI,
      text: '家里来了陌生客人，猫咪通常会？',
      optionA: QuestionOption(text: '主动靠近闻闻或求蹭', score: 1),
      optionB: QuestionOption(text: '躲起来或在高处观察', score: 0),
    ),
    Question(
      number: 2,
      dimension: Dimension.EI,
      text: '你正在用吸尘器或吹风机，它会？',
      optionA: QuestionOption(text: '保持好奇，在安全距离观察', score: 1),
      optionB: QuestionOption(text: '惊慌逃窜，找地方躲藏', score: 0),
    ),
    Question(
      number: 3,
      dimension: Dimension.EI,
      text: '你大声叫它的名字时，它的反馈是？',
      optionA: QuestionOption(text: '跑过来或大声回应', score: 1),
      optionB: QuestionOption(text: '动动耳朵，继续手头的事', score: 0),
    ),
    Question(
      number: 4,
      dimension: Dimension.NS,
      text: '面对一个刚拆开的空快递盒，它会？',
      optionA: QuestionOption(text: '立刻钻进去研究很久', score: 1),
      optionB: QuestionOption(text: '闻一下就走，没啥兴趣', score: 0),
    ),
    Question(
      number: 5,
      dimension: Dimension.NS,
      text: '带它去一个完全陌生的房间，它会？',
      optionA: QuestionOption(text: '竖起尾巴到处巡逻', score: 1),
      optionB: QuestionOption(text: '贴着墙根走，显得很紧张', score: 0),
    ),
    Question(
      number: 6,
      dimension: Dimension.NS,
      text: '当你拿出一个全新的古怪玩具，它会？',
      optionA: QuestionOption(text: '马上冲上去试探', score: 1),
      optionB: QuestionOption(text: '观察很久，确认安全才靠近', score: 0),
    ),
    Question(
      number: 7,
      dimension: Dimension.FT,
      text: '你在专注办公不理它时，它会？',
      optionA: QuestionOption(text: '踩键盘或挡住屏幕求关注', score: 1),
      optionB: QuestionOption(text: '在旁边自己玩或睡觉', score: 0),
    ),
    Question(
      number: 8,
      dimension: Dimension.FT,
      text: '当你情绪激动（大笑或哭泣），它会？',
      optionA: QuestionOption(text: '靠过来蹭你或温柔叫唤', score: 1),
      optionB: QuestionOption(text: '疑惑地看着你，然后走开', score: 0),
    ),
    Question(
      number: 9,
      dimension: Dimension.FT,
      text: '它是否允许你长时间（>1分钟）抱它？',
      optionA: QuestionOption(text: '很享受，甚至打呼噜', score: 1),
      optionB: QuestionOption(text: '会挣扎，不喜欢被束缚', score: 0),
    ),
    Question(
      number: 10,
      dimension: Dimension.PJ,
      text: '每天早上的讨饭时间，它准时吗？',
      optionA: QuestionOption(text: '随缘，不饿不叫', score: 1),
      optionB: QuestionOption(text: '像闹钟一样精准', score: 0),
    ),
    Question(
      number: 11,
      dimension: Dimension.PJ,
      text: '关于睡觉的位置，它表现出？',
      optionA: QuestionOption(text: '每天换地方，居无定所', score: 1),
      optionB: QuestionOption(text: '有几个固定的"领地"', score: 0),
    ),
    Question(
      number: 12,
      dimension: Dimension.PJ,
      text: '面对碗里剩下的猫粮，它会？',
      optionA: QuestionOption(text: '玩一会儿吃两口', score: 1),
      optionB: QuestionOption(text: '只要放饭，必须一次清空', score: 0),
    ),
  ];

  static const List<Question> _advancedZhExtraQuestions = [
    Question(
      number: 13,
      dimension: Dimension.EI,
      text: '窗外有鸟或虫子时，它的反应是？',
      optionA: QuestionOption(text: '疯狂抓窗户或发出咯咯声', score: 1),
      optionB: QuestionOption(text: '只是安静地盯着看', score: 0),
    ),
    Question(
      number: 14,
      dimension: Dimension.EI,
      text: '面对家里的新成员（如另一只小动物）？',
      optionA: QuestionOption(text: '尝试接触，比较大胆', score: 1),
      optionB: QuestionOption(text: '极度警惕，长时间哈气', score: 0),
    ),
    Question(
      number: 15,
      dimension: Dimension.EI,
      text: '它对"躲猫猫"这种互动游戏的态度？',
      optionA: QuestionOption(text: '参与度极高，喜欢追逐', score: 1),
      optionB: QuestionOption(text: '偶尔参与，更多是看你演', score: 0),
    ),
    Question(
      number: 16,
      dimension: Dimension.NS,
      text: '它是否喜欢垂直空间（爬高、跳柜顶）？',
      optionA: QuestionOption(text: '喜欢攀爬，越险越高越好', score: 1),
      optionB: QuestionOption(text: '喜欢待在地面或低矮处', score: 0),
    ),
    Question(
      number: 17,
      dimension: Dimension.NS,
      text: '换了新牌子的猫砂或猫粮，它的反应？',
      optionA: QuestionOption(text: '很快适应，不怎么挑剔', score: 1),
      optionB: QuestionOption(text: '表现出厌恶，甚至拒绝使用', score: 0),
    ),
    Question(
      number: 18,
      dimension: Dimension.NS,
      text: '当它看到电视/iPad里的动态画面？',
      optionA: QuestionOption(text: '会试图伸手去屏幕里抓', score: 1),
      optionB: QuestionOption(text: '只是看着，知道是假的', score: 0),
    ),
    Question(
      number: 19,
      dimension: Dimension.FT,
      text: '它主动找你"踩奶"（按摩）的频率？',
      optionA: QuestionOption(text: '经常发生，非常依赖', score: 1),
      optionB: QuestionOption(text: '极少发生或从不踩奶', score: 0),
    ),
    Question(
      number: 20,
      dimension: Dimension.FT,
      text: '你出差几天回来，它的反应是？',
      optionA: QuestionOption(text: '疯狂蹭你，委屈地叫', score: 1),
      optionB: QuestionOption(text: '冷淡，仿佛你没离开过', score: 0),
    ),
    Question(
      number: 21,
      dimension: Dimension.FT,
      text: '它犯错被你训斥时，它的反应是？',
      optionA: QuestionOption(text: '显得很委屈，试图讨好', score: 1),
      optionB: QuestionOption(text: '无所谓，甚至想跟你顶嘴', score: 0),
    ),
    Question(
      number: 22,
      dimension: Dimension.PJ,
      text: '它掩埋便便的行为习惯是？',
      optionA: QuestionOption(text: '随心所欲，有时埋不好', score: 1),
      optionB: QuestionOption(text: '完美主义，必须埋到看不见', score: 0),
    ),
    Question(
      number: 23,
      dimension: Dimension.PJ,
      text: '它对"开罐头/零食袋"的声音反应？',
      optionA: QuestionOption(text: '哪怕在睡觉也会瞬间弹起', score: 1),
      optionB: QuestionOption(text: '虽然想要，但动作不急促', score: 0),
    ),
    Question(
      number: 24,
      dimension: Dimension.PJ,
      text: '它的理毛（舔毛）频率如何？',
      optionA: QuestionOption(text: '想起来才舔，偶尔乱乱的', score: 1),
      optionB: QuestionOption(text: '极度爱干净，定时全身打理', score: 0),
    ),
  ];

  static const List<Question> _basicEnQuestions = [
    Question(
      number: 1,
      dimension: Dimension.EI,
      text: 'When unfamiliar guests visit your home, your cat usually...',
      optionA: QuestionOption(
        text: 'Approaches to sniff or ask for pets',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Hides or observes from a high place',
        score: 0,
      ),
    ),
    Question(
      number: 2,
      dimension: Dimension.EI,
      text: 'When you use a vacuum or hair dryer, your cat will...',
      optionA: QuestionOption(
        text: 'Stay curious and watch from a safe distance',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Panic and run away to hide', score: 0),
    ),
    Question(
      number: 3,
      dimension: Dimension.EI,
      text: 'When you call your cat loudly by name, the response is...',
      optionA: QuestionOption(text: 'Runs over or responds loudly', score: 1),
      optionB: QuestionOption(
        text: 'Moves ears and keeps doing its own thing',
        score: 0,
      ),
    ),
    Question(
      number: 4,
      dimension: Dimension.NS,
      text: 'Facing a newly opened cardboard box, your cat will...',
      optionA: QuestionOption(
        text: 'Jump in immediately and explore for a long time',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Sniff once and leave with little interest',
        score: 0,
      ),
    ),
    Question(
      number: 5,
      dimension: Dimension.NS,
      text: 'If taken to a completely unfamiliar room, your cat will...',
      optionA: QuestionOption(
        text: 'Raise tail and patrol everywhere',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Walk along the wall and look nervous',
        score: 0,
      ),
    ),
    Question(
      number: 6,
      dimension: Dimension.NS,
      text: 'When given a weird new toy, your cat will...',
      optionA: QuestionOption(text: 'Pounce and test it right away', score: 1),
      optionB: QuestionOption(
        text: 'Watch for a long time before getting close',
        score: 0,
      ),
    ),
    Question(
      number: 7,
      dimension: Dimension.FT,
      text: 'When you focus on work and ignore your cat, it will...',
      optionA: QuestionOption(
        text: 'Step on keyboard or block screen for attention',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Play or nap quietly nearby', score: 0),
    ),
    Question(
      number: 8,
      dimension: Dimension.FT,
      text:
          'When you are emotionally excited (laughing/crying), your cat will...',
      optionA: QuestionOption(
        text: 'Come over, rub against you, or meow softly',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Look confused, then walk away', score: 0),
    ),
    Question(
      number: 9,
      dimension: Dimension.FT,
      text: 'Does your cat allow being held for over 1 minute?',
      optionA: QuestionOption(text: 'Enjoys it and may purr', score: 1),
      optionB: QuestionOption(
        text: 'Struggles and dislikes restraint',
        score: 0,
      ),
    ),
    Question(
      number: 10,
      dimension: Dimension.PJ,
      text: 'At morning feeding time, your cat is...',
      optionA: QuestionOption(
        text: 'Casual; quiet unless truly hungry',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Precise like an alarm clock', score: 0),
    ),
    Question(
      number: 11,
      dimension: Dimension.PJ,
      text: 'About sleeping spots, your cat tends to...',
      optionA: QuestionOption(
        text: 'Sleep somewhere different every day',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Have a few fixed territories', score: 0),
    ),
    Question(
      number: 12,
      dimension: Dimension.PJ,
      text: 'When there is food left in the bowl, your cat...',
      optionA: QuestionOption(
        text: 'Plays first and takes a few bites',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Always finishes all food once served',
        score: 0,
      ),
    ),
  ];

  static const List<Question> _advancedEnExtraQuestions = [
    Question(
      number: 13,
      dimension: Dimension.EI,
      text: 'When birds or bugs appear outside the window, your cat...',
      optionA: QuestionOption(
        text: 'Scratches window crazily or chatters loudly',
        score: 1,
      ),
      optionB: QuestionOption(text: 'Just watches quietly', score: 0),
    ),
    Question(
      number: 14,
      dimension: Dimension.EI,
      text: 'Facing a new family member (like another pet), your cat...',
      optionA: QuestionOption(
        text: 'Tries to approach and is quite bold',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Is highly alert and hisses for a long time',
        score: 0,
      ),
    ),
    Question(
      number: 15,
      dimension: Dimension.EI,
      text: 'About interactive games like hide-and-seek, your cat is...',
      optionA: QuestionOption(
        text: 'Highly engaged and loves chasing',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Occasionally joins, mostly watches you',
        score: 0,
      ),
    ),
    Question(
      number: 16,
      dimension: Dimension.NS,
      text: 'Does your cat enjoy vertical spaces (climbing/jumping high)?',
      optionA: QuestionOption(
        text: 'Loves climbing, the higher and riskier the better',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Prefers the ground or low places',
        score: 0,
      ),
    ),
    Question(
      number: 17,
      dimension: Dimension.NS,
      text: 'When switching to a new litter or food brand, your cat...',
      optionA: QuestionOption(
        text: 'Adapts quickly and is not picky',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Shows dislike or even refuses it',
        score: 0,
      ),
    ),
    Question(
      number: 18,
      dimension: Dimension.NS,
      text: 'When seeing moving images on TV/iPad, your cat...',
      optionA: QuestionOption(text: 'Tries to reach into the screen', score: 1),
      optionB: QuestionOption(
        text: 'Just watches and knows it is fake',
        score: 0,
      ),
    ),
    Question(
      number: 19,
      dimension: Dimension.FT,
      text: 'How often does your cat knead on you voluntarily?',
      optionA: QuestionOption(text: 'Very often, strongly dependent', score: 1),
      optionB: QuestionOption(text: 'Rarely or never kneads', score: 0),
    ),
    Question(
      number: 20,
      dimension: Dimension.FT,
      text: 'After you return from a business trip, your cat...',
      optionA: QuestionOption(
        text: 'Rubs crazily and meows in complaint',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Acts cold, as if you never left',
        score: 0,
      ),
    ),
    Question(
      number: 21,
      dimension: Dimension.FT,
      text: 'When scolded after doing something wrong, your cat...',
      optionA: QuestionOption(
        text: 'Looks wronged and tries to please you',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Does not care and may even argue back',
        score: 0,
      ),
    ),
    Question(
      number: 22,
      dimension: Dimension.PJ,
      text: 'Your cat\'s litter-covering habit is...',
      optionA: QuestionOption(
        text: 'Random, sometimes poorly covered',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Perfectionist, must hide it completely',
        score: 0,
      ),
    ),
    Question(
      number: 23,
      dimension: Dimension.PJ,
      text: 'Hearing can-opening or snack-bag sounds, your cat...',
      optionA: QuestionOption(
        text: 'Jumps up instantly even from sleep',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Wants it but moves less urgently',
        score: 0,
      ),
    ),
    Question(
      number: 24,
      dimension: Dimension.PJ,
      text: 'How frequent is your cat\'s grooming (licking)?',
      optionA: QuestionOption(
        text: 'Only sometimes; coat may look messy',
        score: 1,
      ),
      optionB: QuestionOption(
        text: 'Very clean; grooms on a regular routine',
        score: 0,
      ),
    ),
  ];

  static const List<Question> _basicJaQuestions = [
    Question(
      number: 1,
      dimension: Dimension.EI,
      text: '家に知らないお客さんが来たとき、うちの猫は？',
      optionA: QuestionOption(text: '自分から近づいて匂いを嗅ぎにいく／すり寄る', score: 1),
      optionB: QuestionOption(text: '隠れるか、高い場所から様子を見る', score: 0),
    ),
    Question(
      number: 2,
      dimension: Dimension.EI,
      text: '掃除機やドライヤーを使っているとき、うちの猫は？',
      optionA: QuestionOption(text: '好奇心を保ちつつ、安全な距離で観察する', score: 1),
      optionB: QuestionOption(text: 'びっくりして逃げ、身を隠す', score: 0),
    ),
    Question(
      number: 3,
      dimension: Dimension.EI,
      text: '名前を大きな声で呼んだときの反応は？',
      optionA: QuestionOption(text: '走ってくる、または鳴いて返事する', score: 1),
      optionB: QuestionOption(text: '耳だけ動かして、やっていることを続ける', score: 0),
    ),
    Question(
      number: 4,
      dimension: Dimension.NS,
      text: '開けたばかりの段ボール箱を前にすると？',
      optionA: QuestionOption(text: 'すぐに入ってしばらく探検する', score: 1),
      optionB: QuestionOption(text: 'ひと嗅ぎして、あまり興味を示さず離れる', score: 0),
    ),
    Question(
      number: 5,
      dimension: Dimension.NS,
      text: 'まったく知らない部屋に連れていくと？',
      optionA: QuestionOption(text: 'しっぽを立てて積極的に巡回する', score: 1),
      optionB: QuestionOption(text: '壁沿いに慎重に歩き、緊張している', score: 0),
    ),
    Question(
      number: 6,
      dimension: Dimension.NS,
      text: '新しくて少し変わったおもちゃを出すと？',
      optionA: QuestionOption(text: 'すぐ飛びついて確かめる', score: 1),
      optionB: QuestionOption(text: 'しばらく観察して安全を確かめてから近づく', score: 0),
    ),
    Question(
      number: 7,
      dimension: Dimension.FT,
      text: 'あなたが仕事に集中していて構わないときは？',
      optionA: QuestionOption(text: 'キーボードに乗るなどして注目を求める', score: 1),
      optionB: QuestionOption(text: '近くで一人遊びするか寝て待つ', score: 0),
    ),
    Question(
      number: 8,
      dimension: Dimension.FT,
      text: 'あなたが大笑いしたり泣いたりしているときは？',
      optionA: QuestionOption(text: '寄ってきて体をこすりつけたり優しく鳴いたりする', score: 1),
      optionB: QuestionOption(text: '不思議そうに見て、しばらくして離れる', score: 0),
    ),
    Question(
      number: 9,
      dimension: Dimension.FT,
      text: '1分以上の抱っこを許してくれる？',
      optionA: QuestionOption(text: '比較的平気で、喉を鳴らすこともある', score: 1),
      optionB: QuestionOption(text: 'すぐに嫌がって逃れようとする', score: 0),
    ),
    Question(
      number: 10,
      dimension: Dimension.PJ,
      text: '朝のごはんタイム、うちの猫は？',
      optionA: QuestionOption(text: '気分次第で、空腹でなければ静か', score: 1),
      optionB: QuestionOption(text: '目覚ましのように毎日正確に催促する', score: 0),
    ),
    Question(
      number: 11,
      dimension: Dimension.PJ,
      text: '寝る場所の傾向は？',
      optionA: QuestionOption(text: '毎日違う場所で寝ることが多い', score: 1),
      optionB: QuestionOption(text: 'お気に入りの定位置がいくつかある', score: 0),
    ),
    Question(
      number: 12,
      dimension: Dimension.PJ,
      text: 'お皿にごはんが残っているときは？',
      optionA: QuestionOption(text: '遊びながら少しずつ食べる', score: 1),
      optionB: QuestionOption(text: '出された分をきっちり食べ切る', score: 0),
    ),
  ];

  static const List<Question> _advancedJaExtraQuestions = [
    Question(
      number: 13,
      dimension: Dimension.EI,
      text: '窓の外に鳥や虫がいるときの反応は？',
      optionA: QuestionOption(text: '窓をカリカリしたり「カカカ」と鳴く', score: 1),
      optionB: QuestionOption(text: '静かにじっと見つめる', score: 0),
    ),
    Question(
      number: 14,
      dimension: Dimension.EI,
      text: '新しい同居動物など新メンバーが来たら？',
      optionA: QuestionOption(text: '自分から近づいて接触を試みる', score: 1),
      optionB: QuestionOption(text: '強く警戒し、長くシャーする', score: 0),
    ),
    Question(
      number: 15,
      dimension: Dimension.EI,
      text: '「かくれんぼ」系の遊びへの反応は？',
      optionA: QuestionOption(text: '積極的に参加して追いかける', score: 1),
      optionB: QuestionOption(text: 'たまに参加するが見ていることが多い', score: 0),
    ),
    Question(
      number: 16,
      dimension: Dimension.NS,
      text: '高い場所（登る・ジャンプ）は好き？',
      optionA: QuestionOption(text: '高所が大好きでどんどん挑戦する', score: 1),
      optionB: QuestionOption(text: '床や低い場所を好む', score: 0),
    ),
    Question(
      number: 17,
      dimension: Dimension.NS,
      text: '猫砂やフードの銘柄を変えたときは？',
      optionA: QuestionOption(text: '比較的すぐ慣れてあまり気にしない', score: 1),
      optionB: QuestionOption(text: '嫌がって、使う/食べるのを拒否することがある', score: 0),
    ),
    Question(
      number: 18,
      dimension: Dimension.NS,
      text: 'TVやiPadの動く映像を見ると？',
      optionA: QuestionOption(text: '画面に手を伸ばして捕まえようとする', score: 1),
      optionB: QuestionOption(text: '見てはいるが「本物ではない」と分かっているようだ', score: 0),
    ),
    Question(
      number: 19,
      dimension: Dimension.FT,
      text: '自分から「ふみふみ」しに来る頻度は？',
      optionA: QuestionOption(text: 'よくある。甘えが強め', score: 1),
      optionB: QuestionOption(text: 'ほとんどない／まったくしない', score: 0),
    ),
    Question(
      number: 20,
      dimension: Dimension.FT,
      text: '数日ぶりに帰宅したときの反応は？',
      optionA: QuestionOption(text: '激しくすり寄って鳴き、甘える', score: 1),
      optionB: QuestionOption(text: 'そっけなく、いなかったかのように振る舞う', score: 0),
    ),
    Question(
      number: 21,
      dimension: Dimension.FT,
      text: 'いたずらを叱られたときは？',
      optionA: QuestionOption(text: 'しょんぼりして機嫌を取ろうとする', score: 1),
      optionB: QuestionOption(text: 'あまり気にせず、むしろ反抗的な態度', score: 0),
    ),
    Question(
      number: 22,
      dimension: Dimension.PJ,
      text: '排便後に砂をかける習慣は？',
      optionA: QuestionOption(text: '気分次第で、雑なときもある', score: 1),
      optionB: QuestionOption(text: '見えなくなるまで丁寧に埋める', score: 0),
    ),
    Question(
      number: 23,
      dimension: Dimension.PJ,
      text: '缶詰やおやつ袋の音への反応は？',
      optionA: QuestionOption(text: '寝ていても即反応して飛び起きる', score: 1),
      optionB: QuestionOption(text: '欲しがるが、慌てずゆっくり来る', score: 0),
    ),
    Question(
      number: 24,
      dimension: Dimension.PJ,
      text: '毛づくろい（グルーミング）の頻度は？',
      optionA: QuestionOption(text: '気が向いたときだけで、毛並みが乱れがち', score: 1),
      optionB: QuestionOption(text: 'こまめに毛づくろいして、いつもきれい', score: 0),
    ),
  ];

  static List<Question> getQuestions(
    TestMode mode, {
    required String languageCode,
  }) {
    final normalizedLanguageCode = switch (languageCode) {
      'en' => 'en',
      'ja' => 'ja',
      _ => 'zh',
    };

    final basic = switch (normalizedLanguageCode) {
      'en' => _basicEnQuestions,
      'ja' => _basicJaQuestions,
      _ => _basicZhQuestions,
    };
    if (mode == TestMode.basic) return basic;

    final advancedExtra = switch (normalizedLanguageCode) {
      'en' => _advancedEnExtraQuestions,
      'ja' => _advancedJaExtraQuestions,
      _ => _advancedZhExtraQuestions,
    };
    return [...basic, ...advancedExtra];
  }
}
