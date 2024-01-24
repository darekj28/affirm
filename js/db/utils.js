export const sequelizeLogger = (...msg) => {
  if (process.env.NO_LOG) {
    return;
  }
  console.log('DB Message:', msg);
};
