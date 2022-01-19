# Automated Reinforcement Learning (AutoRL): A Survey and Open Problems

## これはどんな論文？

強化学習（RL）における超パラメタやアルゴリズムのチューニングを自動で行う（AutoRL）方法について，
現状をまとめた総説論文。

## 強化学習（Reinforcement Learning; RL）

自らのふるまいによって変化していく環境に対する適切な振る舞い方を，
試行錯誤を通じて学習していくアルゴリズム。

### 応用例

- ゲームをプレイさせる: [ブロック崩し][1]
- ロボティクス: [ロボットの手で複雑な運指][2]
    + 関連: [弊社野島さんの記事][3]

### 強化学習の難点

- チューニングが難しい: 超パラメタの変化やDNNのアーキテクチャに対してセンシティブ

## 自動強化学習（AutoRL）

強化学習パイプラインのチューニングを自動化することを目標とする一連の方法ないし研究分野。

### 応用例

- [RNAの設計][4]
- [AlphaGoをベイズ最適化][5]

[1]: https://www.youtube.com/watch?v=V1eYniJ0Rnk
[2]: https://www.youtube.com/watch?v=6fo5NhnyR8I
[3]: https://blog.albert2005.co.jp/2022/01/19/qt-opt-and-offline-data-experiment/
[4]: https://arxiv.org/abs/1812.11951
[5]: https://arxiv.org/abs/1812.06855

## 強化学習の基礎

### Markov決定過程（Markov Decision Process; MDP）

- 7つ組$(S, \mathcal{A}, P, R, \rho_0, T, \gamma)$
    + 状態空間: $S$
    + 行動空間: $\mathcal{A}$
    + 状態遷移関数: $P: S \times \mathcal{A} \to S$
        * この状態である行動を取るとその状態に遷移するというルール。
    + 報酬関数: $R: S \times \mathcal{A} \times S \to \mathbb{R}^+$
        * この状態である行動を取ってその状態になるとこれだけ嬉しいことがあるというルール。
    + 初期状態分布: $\rho_0$
    + 終端状態の集合: $T$
        * 状態遷移のゴールなど？
    + 割引率: $\gamma$
        * 累積報酬（これからこういう一連の行動列をとると将来累積でこれだけの報酬がもらえる）を
          計算する際に将来の報酬をこの割引率で現在価値に換算して足し上げる。

### 部分観測Markov決定過程（Partially Observed MDP; POMDP）

- MDPでは状態が見えていたが，POMDPでは状態は隠れ変数で，そこから出るシグナルを観察して学習する。

### RLの目的

- PO/MDPにおいて，累積報酬の期待値$J(\theta; \zeta) = \mathbb{E}_{\tau ~ \pi_\theta}\left[\sum_{t \ge 0}
  \gamma^t r_t\right]$を最大化する方策$\pi_\theta: S \to \mathcal{A}$をみつけること（本文中Eq. (1)）。
    + $\theta$は方策のパラメタ
    + $\zeta$は超パラメタ
- こちらを本論文ではinner loopと呼ぶ。

### AutoRLの目的

- $\max_\zeta f(\zeta, \theta^*)$ s.t. $\theta^* \in \underset{\theta}{\operatorname{arg max}} J(\theta; \zeta)$
    + $f$は，超パラメタ$\zeta$における最適方策のパラメタ$\theta^*$に対する評価。例えば汎化性能など。
- こちらを本論文ではouter loopと呼ぶ。

## Inner loopの最適化

### モデルフリーな方法

- 方策勾配法: $$（本文中Eq. (3)）を使って$\theta_{t+1} = \theta_t + \alpha \nabra_\theta J(\theta)$
  のように学習する。
- 価値ベースの方法: ある状態のときにある行動を取ることの価値$Q_\theta(s, a)$（本文中Eq.
  (4)）を使って学習する。
    + 例: temporal difference learning: 行動する前$Q_\theta(s_t, a_t)$と後$r_t + \gamma \max_a
      Q_\theta(s_{t+1}, a)$の価値の差temporal differenceを使って学習する。

### モデルベースな方法

- 状態遷移関数と報酬関数のパラメトリックなモデルを使って学習する。
    + 例：AlphaGo

## 何を自動化するのか？

TBD

## Outer loopの最適化

### ランダム/グリッド探索

### Bayes最適化

### 進化的方法

### 集団ベースの方法

### メタ勾配によるオンラインチューニング

### ブラックボックスなオンラインチューニング

### 学習アルゴリズムの学習

### 環境の設計

### ハイブリッドな方法

