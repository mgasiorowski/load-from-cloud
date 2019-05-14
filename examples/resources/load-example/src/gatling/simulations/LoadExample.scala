import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._


class LoadExample extends Simulation {
  val usersPerSecond = sys.env.getOrElse("USERS_PER_SECOND", 5)
  val durationTime = sys.env.getOrElse("DURATION_TIME", 2)
  val baseUrl = sys.env.getOrElse("BASE_URL", "https://github.com/")

  val httpProtocol = http
    .baseUrl(baseUrl.toString)
    .acceptHeader("*/*")
    .userAgentHeader("Mozilla/5.0 (compatible; LC/Gatling/4.0.0; +http://example.com/bot.html)")
    .shareConnections

  val scn = scenario("LoadExample")
    .exec(http("home_page")
      .get("/"))

  setUp(
    scn.inject(
      constantUsersPerSec(usersPerSecond.toString.toInt) during (durationTime.toString.toInt seconds)
    )
  )
  .protocols(httpProtocol)
  .maxDuration(durationTime.toString.toInt seconds)
}
