#!/usr/bin/env node
// [HTTPS | Node.js v19.2.0 Documentation](https://nodejs.org/api/https.html)
// [GitHub - jsdom/jsdom: A JavaScript implementation of various web standards, for use with Node.js](https://github.com/jsdom/jsdom)

// npm i -g https jsdom
require.main.paths.push('/usr/local/lib/node_modules');
const https = require('https');
const jsdom = require('jsdom');
const { JSDOM } = jsdom;
const { argv } = require('process');
const url = `https://ejje.weblio.jp/content/${argv[2]}`;
// const url = `https://ejje.weblio.jp/content/dot`;

https.get(url, res => {
  let html = '';
  res.on('data', chunk => {
    html += chunk;
    // console.log(`html chunk: ${chunk}`);
  });
  res.on('end', () => {
    const dom = new JSDOM(html);
    const doc = dom.window.document;
    /**
     * pass the result to CLI
     *
     * @param {string | Element} label
     * @param {string} query
     */
    const logout_ = (label, query, callback, ...args) => {
      // console.log(typeof label);
      // console.log(Object.prototype.toString.call(label));
      // console.log(label.constructor);
      // console.log(label instanceof Object);

      if (callback) {
        callback(label, query, ...args)
        return
      }
      if (!query) {
        console.log(label)
        return
      }

      console.log(...format([label, doc.querySelector(query).textContent]));
    }

    const all = (label, query, index, index2) => {
      if (index2 === undefined) index2 = index
      const nodes = [doc.querySelectorAll(label), doc.querySelectorAll(query)]
      if (nodeNotFound(nodes)) return
      if (!isNodeExists(nodes[0], index)) return
      if (!isNodeExists(nodes[1], index2)) return
      console.log(...format([
        nodes[0][index].textContent,
        nodes[1][index2].textContent,
      ]));
    }
    const oneAll = (label, query, index) => {
      const nodes = [doc.querySelector(label), doc.querySelectorAll(query)]
      if (nodeNotFound(nodes)) return
      console.log(...format([
        nodes[0].textContent,
        nodes[1][index].textContent,
      ]));
    }
    const allOne = (label, query, index) => {
      const nodes = [doc.querySelectorAll(label), doc.querySelector(query)]
      if (nodeNotFound(nodes)) return
      console.log(...format([
        nodes[0][index].textContent,
        nodes[1].textContent,
      ]));
    }
    const oneOne = (label, query) => {
      const nodes = [doc.querySelector(label), doc.querySelector(query)]
      if (nodeNotFound(nodes)) return
      console.log(...format([
        nodes[0].textContent,
        nodes[1].textContent,
      ]));
    }

    // logout_('title', 'h1')
    // 例文
    let buffer
    doc.querySelectorAll('.qotHS ~ div > p').forEach((node, index) => {
      if (index % 2 === 0) {
        buffer = node.textContent.replace('発音を聞く', '').replace('例文帳に追加', '')
      } else {
        console.log(`${buffer}\t\t\t${node.textContent}`)
        buffer = ''
      }
    })
    console.log('=================================')
    // 可算名詞・不可算名詞
    // doc.querySelectorAll('.intrst').forEach(node => {
    //   if (node.textContent.includes('可算名詞')) console.log('可算名詞')
    //   if (node.textContent.includes('不可算名詞')) console.log('不可算名詞')
    // })
    // document.querySelector('.KejjeSm').innerText

    // 音声リンク
    sounds = doc.querySelector('.contentAudio source')
    if (sounds !== null) logout_(sounds.src)
    console.log('=================================')
    // 意味
    logout_('.summaryM.descriptionWrp span:nth-of-type(1)', '.summaryM.descriptionWrp span:nth-of-type(2)', oneOne)
    // 発音記号
    logout_('.KejjeLb', '.KejjeHt', allOne, 1)
    // 品詞変形
    logout_('#summary td.intrstL', '#summary td.intrstR table', all, 1, 0)
  });
});

const format = str => str.map(x => x.replace('\n', '').trim())
const nodeNotFound = ary => ary.some(x => x === null)
const isNodeExists = (node , index) => node.length > index
