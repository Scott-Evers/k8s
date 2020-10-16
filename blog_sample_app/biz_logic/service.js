const l = console.log
const http = require('http')




const svr = http.createServer((client_req, client_res) => {

  if (!client_req.url.startsWith('/blog')) {
    client_res.writeHead(404, { 'Content-Type': 'text/plain' })
    client_res.end('not found')
    return
  }

  const options = {
    hostname: 'localhost',
    port: 1337,
    path: client_req.url,
    method: client_req.method,
    headers: client_req.headers
  }
  
  const proxy = http.request(options, (res) => {
    client_res.writeHead(res.statusCode,res.headers)
    
    if (res.statusCode == 200 && options.method == 'GET') {
        let data = ''
        res.on('data', (chunk) => { data += chunk })
        res.on('end', () => {
            let unsorted = JSON.parse(data)
            let sorted = {}
            Object.keys(unsorted).sort(function ( a, b ) { return b - a; }).forEach(function(key) {
                sorted[key] = unsorted[key];
              })
            client_res.end(JSON.stringify(sorted))
        })
        
    }
    else {
        res.pipe(client_res, {end:true})
    }
  })
  
  client_req.pipe(proxy, {end:true})

})


svr.listen(1338,'0.0.0.0')


