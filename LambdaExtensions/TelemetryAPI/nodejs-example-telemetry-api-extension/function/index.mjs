console.log("Hello from function initalization");

export const handler = async (event, context) => {
  console.log(JSON.stringify(event));
};
