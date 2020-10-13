const l = console.log
const http = require('http')
const fs = require('fs')




const svr = http.createServer((req, res) => {
  if (!req.url.startsWith('/blog')) {
    res.writeHead(404, { 'Content-Type': 'text/plain' })
    res.end('not found')
    return
  }
  switch (req.method) {
    case 'GET':
      let posts = {}
      files = fs.readdirSync('posts')
      for (let i = 0; i < files.length; i++)
        posts[files[i]] = fs.readFileSync(`posts/${files[i]}`).toString()
      res.writeHead(200, { 'Content-Type': 'applicatoin/json' })
      res.write(JSON.stringify(posts))
      res.end()
      break
    case 'POST':
      let body = "";
      req.on('data', (chunk) => {
        body += chunk;
      })
      req.on('end', () => {
        console.log('POSTed: ' + body);
        fs.writeFileSync(`posts/${Date.now()}`,body)
        res.writeHead(200);
        res.end('posted')
      })
          
      break
    default:
      res.writeHead(405, { 'Content-Type': 'text/plain' })
      res.end('method not allowed')
  }
  });


svr.listen(1337,'127.0.0.1')


