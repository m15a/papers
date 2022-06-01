# The dip test of unimodality

## これはどんな論文？

- サンプルが単峰な分布から得られたものかどうかを統計的に検定する方法を考案した論文。

## dip

経験分布関数と最も近い単峰な分布関数との距離が最大となる点での距離をdipと呼ぶ。

有界な関数$F$, $G$に対して

$$
\rho(F, G) = \sup_x \left| F(x) - G(x) \right|
$$

とする。また有界な関数のクラス$\mathscr{A}$について，

$$
\rho(F, \mathscr{A}) = \inf_{G \in \mathscr{A}} \rho(F, G)
$$

と定義する。関数$F$との差の最大値が最小となるような$G$を選んでいる。

分布関数$F$と単鋒な分布のクラス$\mathscr{U}$との上記の「距離」

$$
D(F) = \rho(F, \mathscr{U})
$$

をdipと定義する。

dipは単峰な分布からの逸脱度を表す量となっている。$F$が単峰な分布関数であれば$D(F) = 0$となる。

## References

- Hartigan, J. A., Hartigan, P. M. (1985) The dip test of unimodality. _The Annals of Statistics_, 13, 70--84. http://www.jstor.org/stable/2241144
- Ross, E. (2020, Aug. 21) _Dip statistics for multimodality_. Skeptic. https://skeptric.com/dip-statistic/
