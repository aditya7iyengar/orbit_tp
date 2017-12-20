defmodule OrbitTp.ComponentApplier.Gravity do
  @moduledoc false

  use OrbitTp.ComponentApplier

  alias OrbitTp.{Body, Gravity}

  def run(system, time) do
    {body1, body2} = apply(system, :bodies, [])
    updated_at = apply(system, :updated_at, [])

    body1 = Body.get_body(body1)
    body2 = Body.get_body(body2)

    distance = get_body_distance(body1, body2)

    time_period = Gravity.time_period(body1.mass, body2.mass, distance)

    effectivetime = time - updated_at

    {ang1, rad1} = ang_and_rad(body1.mass, body2.mass, distance, time_period)
    {x1, y1} = get_position(body1, ang1, rad1, effectivetime)

    {ang2, rad2} = ang_and_rad(body2.mass, body1.mass, distance, time_period)
    {x2, y2} = get_position(body2, ang2, rad2, effectivetime)

    apply(system, :update_bodies,
          [%Body{body1 | x: x1, y: y1}, %Body{body2 | x: x2, y: y2}])

    apply(system, :update_time, [time])
  end

  def get_body_distance(%Body{x: x1, y: y1}, %Body{x: x2, y: y2}) do
    (:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
    |> :math.pow(0.5)
  end

  def ang_and_rad(m1, m2, d, time_period) do
    radius = Gravity.com_distance(m1, m2, d)
    {2 * :math.pi * radius / time_period, radius}
  end

  def get_position(%Body{x: xi, y: yi}, angular_speed, radius, time) do
    theta_i = xi == 0 && :math.pi/2 || :math.atan(yi / xi)
    theta_t = theta_i + angular_speed * time
    {:math.cos(theta_t) * radius, :math.sin(theta_t) * radius}
  end
end
