const { ApolloServer, gql } = require("apollo-server");
const mysql = require("mysql2/promise");

// Create MySQL connection pool
const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "movieDB",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

const typeDefs = gql`
  type Movie {
    movie_id: ID!
    title: String!
    release_date: String!
    genre: String!
    runtime: String
    rating: String
    budget: Int
    collection: Int
  }

  type Query {
    movies: [Movie]!
  }
`;

const resolvers = {
  Query: {
    movies: async () => {
      const [rows] = await pool.query("SELECT * FROM movies");
      return rows;
    },
  },
};

const server = new ApolloServer({ typeDefs, resolvers });
server
  .listen({ port: 9000 })
  .then(({ url }) => console.log(`Server running at ${url}`));
