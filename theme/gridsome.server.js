const config = require('./package.json').schole;
const projectSlug = config.project;

const axios = require('axios');

const getDocumentsQuery = (projectSlug) => {
  return `query {
    findProjects(slug:"${projectSlug}") {
      documents {
        title
        content
      }
    }
  }`
}

const getDocuments = (slug) => {
  const query = getDocumentsQuery(slug);

  return axios({
    method: 'POST',
    url: 'http://localhost:4000/graphql',
    data: {
      query: query
    }
  })
  .then(res => res.data);
}

module.exports = function (api) {
  api.loadSource(({ addMetadata }) => {
    addMetadata('settings', require('./gridsome.config').settings);
  });

  api.createPages(async ({ createPage }) => {
    const { data } = await getDocuments(projectSlug);

    data.findProjects[0].documents.forEach(doc => {
      // TODO
    });
  });
}
