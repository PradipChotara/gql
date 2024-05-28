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

  type roletype {
    roletype_id: ID!
    type_name: String
    created_at: String
  }

  type Person {
    person_id: ID
    name: String
    roletype_id: Int
    roletype: [roletype]
    created_at: String
  }

  type Query {
    movies: [Movie]!
    roletype: [roletype]
    persons: [Person]
  }
`;

const resolvers = {
  Query: {
    movies: async () => {
      const [rows] = await pool.query("SELECT * FROM movies");
      return rows;
    },
    roletype: async () => {
      const [rows] = await pool.query("SELECT * FROM roletype");
      return rows;
    },
    persons: async () => {
      const persons = await pool.query("SELECT * FROM person");

      const personsWithRoleType = await Promise.all(
        persons.map(async (person) => {
          let roleTypes = [];
          if (person.roletype_id !== null) {
            const [rows] = await pool.query(
              "SELECT * FROM roletype WHERE roletype_id = ?",
              [person.roletype_id]
            );
            roleTypes = rows;
          }
          return { ...person, roleTypes };
        })
      );

      return personsWithRoleType;
    },
  },
};

const server = new ApolloServer({ typeDefs, resolvers });
server
  .listen({ port: 9000 })
  .then(({ url }) => console.log(`Server running at ${url}`));
