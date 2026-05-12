const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 0;
const HOST = '127.0.0.1';

// 可执行文件所在目录（兼容 pkg 打包后的路径）
const isPkg = typeof process.pkg !== 'undefined';
const baseDir = isPkg ? path.dirname(process.execPath) : __dirname;
const WEB_DIR = path.join(baseDir, 'web');

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js':   'application/javascript; charset=utf-8',
  '.css':  'text/css; charset=utf-8',
  '.png':  'image/png',
  '.jpg':  'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif':  'image/gif',
  '.svg':  'image/svg+xml',
  '.ico':  'image/x-icon',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',
  '.map':  'application/json',
};

function serveFile(res, filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const contentType = MIME_TYPES[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('404 Not Found');
      return;
    }
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
}

const server = http.createServer((req, res) => {
  let urlPath = req.url.split('?')[0];
  if (urlPath === '/') urlPath = '/index.html';

  const filePath = path.join(WEB_DIR, urlPath);

  if (!filePath.startsWith(WEB_DIR)) {
    res.writeHead(403, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Forbidden');
    return;
  }

  serveFile(res, filePath);
});

server.listen(PORT, HOST, () => {
  const addr = server.address();
  const url = `http://${HOST}:${addr.port}`;
  console.log('┌──────────────────────────────────────┐');
  console.log('│                                      │');
  console.log('│   WMS Demo 仓库管理系统              │');
  console.log('│                                      │');
  console.log(`│   → ${url.padEnd(34)}│`);
  console.log('│                                      │');
  console.log('│  关闭此窗口即可停止服务               │');
  console.log('└──────────────────────────────────────┘');

  // 自动打开浏览器
  const cmd = process.platform === 'darwin' ? `open "${url}"`
    : process.platform === 'win32' ? `start "" "${url}"`
    : `xdg-open "${url}"`;

  require('child_process').exec(cmd, () => {});
});
