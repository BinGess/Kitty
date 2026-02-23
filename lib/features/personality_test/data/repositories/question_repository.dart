import '../models/question.dart';

class QuestionRepository {
  static const List<Question> basicQuestions = [
    // E/I 维度 (题1-3)
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

    // N/S 维度 (题4-6)
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

    // F/T 维度 (题7-9)
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

    // P/J 维度 (题10-12)
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

  static const List<Question> advancedExtraQuestions = [
    // E/I 额外 (题13-15)
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

    // N/S 额外 (题16-18)
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

    // F/T 额外 (题19-21)
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

    // P/J 额外 (题22-24)
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

  static List<Question> getQuestions(TestMode mode) {
    if (mode == TestMode.basic) return basicQuestions;
    return [...basicQuestions, ...advancedExtraQuestions];
  }
}
