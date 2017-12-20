defmodule OrbitTp.Gravity do
  def force(m1, m2, d) do
    ugc() * m1 * m2 / :math.pow(d, 2)
  end

  def time_period(m1, m2, d) do
    speed1 = get_speed(m2, d)
    2 * com_distance(m1, m2, d) / speed1
  end

  defp com_distance(m, m_other, d), do: m_other/(m + m_other) * d

  defp get_speed(m_other, d) do
    vsq = ugc() * m_other/ d
    :math.pow(vsq, 0.5)
  end

  defp ugc, do: 6.67 * :math.pow(10, -11)
end
