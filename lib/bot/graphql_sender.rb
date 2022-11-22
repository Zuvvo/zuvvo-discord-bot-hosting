require "graphql/client"
require "graphql/client/http"

module GraphqlSender

  URL = 'https://zuvvo-discord-bot.herokuapp.com/graphql'

  HTTP = GraphQL::Client::HTTP.new(URL) do
    def headers(context)
      {

      }
    end
  end

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  SendExampleGameQuery = GraphqlSender::Client.parse <<~GQL
      mutation ($game_results: String!, $host: String!, $game_time: Int!, $game_difficulty: Int!, $riddles_count: Int!) {
        createMathGameMutation(
          input: {results: $game_results,
            hostName: $host,
            time: $game_time,
            difficulty: $game_difficulty,
            riddlesCount: $riddles_count}
        ) {
          mathGame {
            id
          }
        }
      }
  GQL

  def send_mutation_query(game)
    result = Client.query(
      SendExampleGameQuery,
      variables: {game_results: game.results.to_s, host: game.game_host_name,
                  game_time: game.time_for_answer, game_difficulty: game.difficulty,
                  riddles_count: game.riddles.size } )
    puts result
  end
end