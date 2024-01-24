import sequelize from '../db/index'

// Check our db is working
sequelize
  .authenticate()
  .then(() => console.log('Connected to DB'))
  .catch(e => {
    console.log(`Facing an issue with Test DB Sequelize \n ${JSON.stringify({ error }, undefined, 2)}`);
  });

// DB connection to be synced / closed when test suite starts / ends
export const syncDb = async () => await sequelize.sync({ force: true });
export const closeDb = async () => await sequelize.close();
