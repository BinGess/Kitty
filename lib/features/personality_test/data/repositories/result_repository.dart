import '../models/personality_type.dart';

class ResultRepository {
  static const Map<String, PersonalityType> _zhTypes = {
    'ENFP': PersonalityType(
      code: 'ENFP',
      title: '快乐小天使',
      tags: ['#社牛', '#话痨', '#好奇宝宝'],
      description:
          '这只猫是天生的交际花！对所有人和事物都充满热情，一个快递盒就能让它快乐一整天。喜欢在人群中穿梭表演，随时发出热情的呼噜声。它的世界没有陌生人，只有还没交到的朋友。',
      advice: '给它丰富的社交环境和新鲜玩具，它需要不断的刺激来保持快乐。但要注意，它可能会因为太兴奋而忘记吃饭！',
      quote: '"每天都是最好的一天喵！"',
    ),
    'ENFJ': PersonalityType(
      code: 'ENFJ',
      title: '猫界班长',
      tags: ['#领袖气质', '#操心命', '#暖心'],
      description:
          '天生的领导者，总是关注着家里每个成员的动态。它会在你伤心时主动靠过来安慰，在你忘记喂食时提醒你。如果家里有其他宠物，它一定是那个维持秩序的"大家长"。',
      advice: '它需要被重视和感谢，记得多给它正面反馈。让它参与家庭活动，它会觉得自己很重要！',
      quote: '"大家都好好的，我就放心了喵~"',
    ),
    'ENTP': PersonalityType(
      code: 'ENTP',
      title: '捣蛋鬼王',
      tags: ['#搞破坏', '#小机灵', '#不服管'],
      description:
          '这只猫是个天才加捣蛋鬼。它能想出各种方法打开柜门、偷零食、把东西从桌上推下去。永远精力旺盛，每天都在探索如何让主人崩溃并乐在其中。它不是不听话，而是规则太无聊。',
      advice: '给它益智玩具和挑战性的环境，比如藏食器、复杂的猫爬架。如果你不给它找事做，它就会自己"找事做"！',
      quote: '"规矩是用来打破的喵！"',
    ),
    'ENTJ': PersonalityType(
      code: 'ENTJ',
      title: '霸道总裁',
      tags: ['#王者风范', '#掌控一切', '#不怒自威'],
      description:
          '家里真正的主人。它有明确的领地意识，固定的作息表，并要求你严格遵守。它的一个眼神就能让你知道该做什么。别试图抱它——除非它允许。在它面前，你只是个被驯化的铲屎官。',
      advice: '尊重它的权威和领地，按时喂食，保持环境稳定。它不喜欢惊喜，但会欣赏你的服从。',
      quote: '"这个家，我说了算喵。"',
    ),
    'ESFP': PersonalityType(
      code: 'ESFP',
      title: '派对动物',
      tags: ['#表演欲', '#人来疯', '#快乐源泉'],
      description:
          '天生的表演者！有人在的时候就是它的舞台时间——翻滚、跳跃、耍宝样样精通。它是家里的开心果，总能用滑稽的动作逗得所有人大笑。安静？不存在的。',
      advice: '多给它观众和互动，它在关注中茁壮成长。可以教它一些小技巧，它学得又快又得意！',
      quote: '"看我看我看我喵！"',
    ),
    'ESFJ': PersonalityType(
      code: 'ESFJ',
      title: '贴心小棉袄',
      tags: ['#黏人精', '#撒娇王', '#暖心'],
      description:
          '全世界最黏人的猫！它会像影子一样跟着你，你走到哪它就到哪。每天固定时间蹭腿、踩奶、打呼噜，仿佛在说"你是我的全世界"。你出差回来？准备好迎接一场委屈的"控诉"吧！',
      advice: '它需要大量的陪伴和身体接触，独处会让它焦虑。如果你经常出门，考虑给它找个伴！',
      quote: '"你今天还没抱我喵..."',
    ),
    'ESTP': PersonalityType(
      code: 'ESTP',
      title: '极限运动员',
      tags: ['#飞檐走壁', '#胆大包天', '#精力无限'],
      description:
          '家里的跑酷高手！从书架跳到冰箱顶，从窗台飞到衣柜——没有它到不了的地方。它对速度和高度有天然的迷恋，每天都在挑战物理极限。偶尔翻车？那也是精彩表演的一部分！',
      advice: '准备高质量的猫爬架和垂直空间，定期陪它玩追逐游戏消耗精力。小心易碎物品！',
      quote: '"更高更快更强喵！"',
    ),
    'ESTJ': PersonalityType(
      code: 'ESTJ',
      title: '纪律委员',
      tags: ['#作息规律', '#洁癖', '#一丝不苟'],
      description:
          '全家最守时的成员。早上6点准时叫你起床喂食，晚上10点准时上床占位置。猫砂盆必须干净、食碗必须满、一切必须按照它的标准来。它不是难伺候，它是有原则。',
      advice: '保持固定的生活规律，按时喂食、按时清理。它讨厌变化，所以尽量少换猫粮品牌和猫砂。',
      quote: '"迟到一分钟，扣鸡肉条一根喵！"',
    ),
    'INFP': PersonalityType(
      code: 'INFP',
      title: '文艺小诗猫',
      tags: ['#发呆', '#敏感', '#独处爱好者'],
      description:
          '一只活在自己世界里的猫。它喜欢找一个安静的角落，长时间凝视窗外的树叶或光影变化。看起来在发呆，实际上在思考猫生的意义。它对你的情绪异常敏感，能察觉你最微小的情感变化。',
      advice: '给它安静的独处空间，窗台是它最爱的位置。不要强迫它社交，让它按自己的节奏来。',
      quote: '"那片云，像一条鱼喵..."',
    ),
    'INFJ': PersonalityType(
      code: 'INFJ',
      title: '神秘预言家',
      tags: ['#第六感', '#高冷外热内', '#通灵'],
      description:
          '全网最有灵性的猫！它能预感到你什么时候要回家，在门口提前等候。它看起来高冷独立，但当你真正需要它时，它总会默默出现在你身边。它选人，不是所有人都能得到它的信任。',
      advice: '耐心建立信任，不要急于亲近。一旦它认定你，就是一辈子的事。给它一个专属的观察高处。',
      quote: '"我知道你需要我喵。"',
    ),
    'INTP': PersonalityType(
      code: 'INTP',
      title: '猫界科学家',
      tags: ['#研究员', '#社恐', '#独行侠'],
      description:
          '这只猫永远在研究什么。水龙头滴水？它能盯着看一小时分析水流规律。新玩具？必须从360度全方位检查。它对人类社交没什么兴趣，但对任何机械装置都充满学术热情。',
      advice: '提供各种可探索的物品和机关玩具，比如转盘、弹簧、滚球。它需要智力刺激多过情感陪伴。',
      quote: '"让我研究一下这个原理喵..."',
    ),
    'INTJ': PersonalityType(
      code: 'INTJ',
      title: '暗影刺客',
      tags: ['#战略家', '#独来独往', '#冷酷'],
      description:
          '家里最神秘的存在。它总是在暗处观察一切，制定精密的狩猎计划。每次出击都一击必中，无论是抓飞虫还是偷小鱼干。它不需要你的关注，但它知道你的一切。沉默，但致命。',
      advice: '给它独立的空间和高处观察点。它欣赏有能力的主人——保持猫砂盆干净、食物新鲜就是最好的尊重。',
      quote: '"一切尽在掌控喵。"',
    ),
    'ISFP': PersonalityType(
      code: 'ISFP',
      title: '佛系艺术家',
      tags: ['#随缘', '#慵懒', '#颜值即正义'],
      description:
          '全网最上镜的猫！它天生知道最美的姿势，随便一躺就是一张明信片。它对生活没什么要求——有阳光、有饭吃、有个舒服的窝就是猫生巅峰。不争不抢，岁月静好。',
      advice: '给它最舒适的环境，柔软的垫子和充足的阳光。它不需要太多互动，但偶尔的温柔抚摸会让它幸福感爆棚。',
      quote: '"躺平，真好喵~"',
    ),
    'ISFJ': PersonalityType(
      code: 'ISFJ',
      title: '忠诚守护者',
      tags: ['#护主', '#念旧', '#安全感'],
      description:
          '你最忠实的伙伴。它可能不会在陌生人面前表现出来，但它永远守在你身边。你的拖鞋旁边、你的枕头旁边、你的书桌旁边——它总是在你能看到的地方。分离焦虑？那是因为爱太深。',
      advice: '给它固定的、安全的环境，它害怕变化。出门前留一件有你味道的衣服给它，能缓解它的焦虑。',
      quote: '"只要你在，哪里都是家喵。"',
    ),
    'ISTP': PersonalityType(
      code: 'ISTP',
      title: '独行侠客',
      tags: ['#我行我素', '#冷静', '#生存专家'],
      description:
          '全家最独立的猫。它不需要你的陪伴、关注或者安慰——它只需要食物和一个能俯瞰全局的位置。它是天生的猎手，反应迅速、判断精准。你以为它不在乎你？其实它只是不擅长表达。',
      advice: '给它自由和空间，不要过度打扰。准备一些模拟狩猎的玩具，保持它的野性本能。',
      quote: '"我一只猫，挺好的喵。"',
    ),
    'ISTJ': PersonalityType(
      code: 'ISTJ',
      title: '老干部',
      tags: ['#稳重', '#传统', '#可靠'],
      description:
          '家里最靠谱的猫。它有固定的吃饭位置、固定的睡觉时间、固定的巡逻路线。从不制造混乱，从不打翻东西，从不在不该叫的时候叫。它是猫界的模范公民，让你省心到几乎忘了它的存在。',
      advice: '维持稳定的环境和规律的生活是对它最大的尊重。它不需要惊喜，需要的是安心和可预测的日常。',
      quote: '"稳定压倒一切喵。"',
    ),
  };

  static const Map<String, PersonalityType> _enTypes = {
    'ENFP': PersonalityType(
      code: 'ENFP',
      title: 'Joyful Little Angel',
      tags: ['#SocialStar', '#Talkative', '#Curious'],
      description:
          'A born social butterfly. This cat is excited about everyone and everything, and a cardboard box can keep it entertained all day. It loves performing around people and purring with enthusiasm.',
      advice:
          'Provide rich social interaction and fresh toys. This type needs frequent stimulation, but remember to keep feeding routines stable so excitement does not interrupt meals.',
      quote: '"Every day is the best day, meow!"',
    ),
    'ENFJ': PersonalityType(
      code: 'ENFJ',
      title: 'Class Monitor',
      tags: ['#Leader', '#Caring', '#WarmHearted'],
      description:
          'A natural leader who keeps track of every family member. It comforts you when you are down and reminds you when meal time is late. In multi-pet homes, this one often acts like the household manager.',
      advice:
          'Give appreciation and positive feedback often. Let this cat join family moments so it feels valued and important.',
      quote: '"As long as everyone is okay, I am okay."',
    ),
    'ENTP': PersonalityType(
      code: 'ENTP',
      title: 'Mischief Master',
      tags: ['#Troublemaker', '#Clever', '#Rebellious'],
      description:
          'A genius prankster. This cat can open cabinets, steal snacks, and push objects off tables with style. Full of energy, it constantly experiments with new ways to challenge your patience.',
      advice:
          'Offer puzzle feeders, climbing challenges, and varied play tasks. If you do not give it missions, it will create its own.',
      quote: '"Rules are made to be broken, meow!"',
    ),
    'ENTJ': PersonalityType(
      code: 'ENTJ',
      title: 'Boss Cat CEO',
      tags: ['#Dominant', '#ControlMode', '#Commanding'],
      description:
          'The true ruler of the home. It has strong territory awareness and a strict routine. One look tells you exactly what it expects. You can hold it only when permission is granted.',
      advice:
          'Respect boundaries and keep daily routines predictable. This cat dislikes random surprises but appreciates consistent care.',
      quote: '"In this house, I make the rules."',
    ),
    'ESFP': PersonalityType(
      code: 'ESFP',
      title: 'Party Animal',
      tags: ['#Performer', '#AttentionLover', '#MoodMaker'],
      description:
          'A stage performer by nature. Rolling, jumping, and funny antics are all part of its show when people are around. Quiet mode is almost never activated.',
      advice:
          'Give this cat an audience and interactive games. Teaching simple tricks works great because it learns fast and loves applause.',
      quote: '"Look at me, look at me, look at me!"',
    ),
    'ESFJ': PersonalityType(
      code: 'ESFJ',
      title: 'Snuggle Sweater',
      tags: ['#Clingy', '#Affectionate', '#Sweet'],
      description:
          'Extremely attached and people-oriented. It follows you like a shadow, asks for cuddles, kneads regularly, and purrs as if saying you are its whole world.',
      advice:
          'Provide lots of companionship and gentle physical contact. Long periods alone can cause anxiety, so enrichment or a companion pet may help.',
      quote: '"You still have not hugged me today..."',
    ),
    'ESTP': PersonalityType(
      code: 'ESTP',
      title: 'Extreme Athlete',
      tags: ['#ParkourCat', '#Fearless', '#UnlimitedEnergy'],
      description:
          'A home parkour expert. Bookshelves, counters, and wardrobe tops are all part of its route. It loves speed, height, and constant action.',
      advice:
          'Prepare strong vertical structures and schedule intense chase play. Keep fragile items out of launch zones.',
      quote: '"Higher, faster, stronger, meow!"',
    ),
    'ESTJ': PersonalityType(
      code: 'ESTJ',
      title: 'Discipline Officer',
      tags: ['#Routine', '#NeatFreak', '#Precise'],
      description:
          'The most punctual member at home. Feeding time, sleeping spots, and litter conditions must follow standards. This cat is not difficult, just principled.',
      advice:
          'Maintain a stable schedule and consistent care habits. Avoid sudden brand changes in food or litter when possible.',
      quote: '"One minute late? Penalty snack deducted."',
    ),
    'INFP': PersonalityType(
      code: 'INFP',
      title: 'Poetic Dreamer',
      tags: ['#Daydreamer', '#Sensitive', '#SolitudeLover'],
      description:
          'A quiet soul living in its own world. It enjoys peaceful corners, watching leaves and light for long periods. Beneath that calm face, deep emotional perception is active.',
      advice:
          'Offer quiet personal space, especially near windows. Let this cat choose the pace of social interaction.',
      quote: '"That cloud looks like a fish..."',
    ),
    'INFJ': PersonalityType(
      code: 'INFJ',
      title: 'Mystic Prophet',
      tags: ['#SixthSense', '#CoolOutsideWarmInside', '#Spiritual'],
      description:
          'A highly intuitive cat that seems to predict your return time. It appears independent and cool, yet quietly shows up when you need comfort the most.',
      advice:
          'Build trust patiently and avoid forcing closeness. Once trust is established, loyalty runs deep.',
      quote: '"I knew you needed me."',
    ),
    'INTP': PersonalityType(
      code: 'INTP',
      title: 'Cat Scientist',
      tags: ['#Researcher', '#SocialShy', '#SoloThinker'],
      description:
          'Always investigating something. Dripping water, moving shadows, or new gadgets can hold this cat for long focused observation sessions.',
      advice:
          'Provide mechanical toys and exploratory objects. Intellectual stimulation matters more than constant cuddling for this type.',
      quote: '"Let me study the mechanism first..."',
    ),
    'INTJ': PersonalityType(
      code: 'INTJ',
      title: 'Shadow Assassin',
      tags: ['#Strategist', '#Independent', '#ColdPrecision'],
      description:
          'A silent observer planning perfect hunts from hidden positions. It may not seek attention, but it tracks everything around it with sharp control.',
      advice:
          'Provide independent zones and elevated observation points. Respect through clean litter and fresh food goes a long way.',
      quote: '"Everything is under control."',
    ),
    'ISFP': PersonalityType(
      code: 'ISFP',
      title: 'Zen Artist',
      tags: ['#GoWithFlow', '#Relaxed', '#Photogenic'],
      description:
          'Naturally elegant and camera-ready. A sunny spot, good food, and a soft bed are enough for peak happiness. Calm, gentle, and low-drama.',
      advice:
          'Create a cozy environment with soft bedding and sunlight. Occasional gentle affection is usually the perfect amount.',
      quote: '"Slow life is the best life."',
    ),
    'ISFJ': PersonalityType(
      code: 'ISFJ',
      title: 'Loyal Guardian',
      tags: ['#Protective', '#Nostalgic', '#SecurityFocused'],
      description:
          'A devoted companion that stays near your routine spaces. It may seem reserved with strangers, but its loyalty to you is steady and visible.',
      advice:
          'Keep the environment stable and comforting. Leaving a familiar-scented item can help when you are away.',
      quote: '"Where you are is home."',
    ),
    'ISTP': PersonalityType(
      code: 'ISTP',
      title: 'Lone Ranger',
      tags: ['#Independent', '#Calm', '#SurvivalExpert'],
      description:
          'Highly independent and practical. It does not demand constant reassurance, but it stays sharp, observant, and capable in its own way.',
      advice:
          'Respect personal space and avoid overhandling. Hunting-style toys help keep natural instincts healthy.',
      quote: '"I do just fine on my own."',
    ),
    'ISTJ': PersonalityType(
      code: 'ISTJ',
      title: 'Senior Cadre',
      tags: ['#Steady', '#Traditional', '#Reliable'],
      description:
          'A model citizen with fixed routines and dependable habits. Calm, orderly, and consistent, this cat rarely causes chaos and values predictability.',
      advice:
          'Preserve routine and environmental stability. For this type, reliability is the greatest comfort.',
      quote: '"Stability above all."',
    ),
  };

  static PersonalityType getType(String code, {required String languageCode}) {
    final map = languageCode == 'en' ? _enTypes : _zhTypes;
    return map[code] ?? map['ISFP']!;
  }
}
