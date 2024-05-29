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
    movie_id: ID
    title: String
    release_date: String
    genre: String
    runtime: String
    rating: String
    budget: Int
    collection: Int
  }

  type RoleType {
    roletype_id: ID
    type_name: String
    created_at: String
  }

  type Person {
    person_id: ID
    name: String
    roletype_id: Int
    roletype: RoleType
    created_at: String
  }

  type Query {
    getMovies: [Movie]
    getRoleType: [RoleType]
    getPersons(offset: Int, limit: Int): [Person]
    getPersonById(id: ID!): Person
  }
`;

const resolvers = {
  Person: {
    roletype: async (person) => {
      const data = await pool.query(
        `SELECT * FROM roletype WHERE roletype.roletype_id = ${person.roletype_id}`
      );
      return data[0][0];
    },
  },
  Query: {
    getMovies: async () => {
      const [rows] = await pool.query("SELECT * FROM movies");
      return rows;
    },
    getRoleType: async () => {
      const [rows] = await pool.query("SELECT * FROM roletype");
      return rows;
    },
    getPersons: async (_, args) => {
      if (args.offset && args.limit) {
        const persons = await pool.query(`SELECT * FROM person LIMIT ${args.limit} OFFSET ${args.offset}`);
        return persons[0];
      }
      const persons = await pool.query("SELECT * FROM person");
      return persons[0];
    },
    getPersonById: async (_, args) => {
      const person = await pool.query(
        `SELECT * FROM person WHERE person.person_id = ${args.id}`
      );
      return person[0][0];
    },
  },
};

const server = new ApolloServer({ typeDefs, resolvers });
server
  .listen({ port: 9000 })
  .then(({ url }) => console.log(`Server running at ${url}`));
