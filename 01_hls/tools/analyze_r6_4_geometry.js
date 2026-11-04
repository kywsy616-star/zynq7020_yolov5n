// Descriptor accounting, not a replacement for RTL/ILA or board timing.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..'),blob=fs.readFileSync(path.join(root,'tools/r5_testdata/layers.bin'));
const previous=JSON.parse(fs.readFileSync(path.join(root,'yolov5n_hls_r6_3_20261016/r6_3_geometry.json'),'utf8'));
const ops=previous.ops.map(old=>{
 const at=old.op*64,d=Array.from({length:16},(_,i)=>blob.readInt32LE(at+4*i));
 const pointwise=old.k===1&&old.s===1&&(d[13]&255)===0&&d[4]<0&&old.ih===old.oh&&old.iw===old.ow;
 let rowWaves=0,packets=0,tiles=0,prefetchDrainRows=0;
 const tileR=d[11]>>>16,validOB=Math.ceil(old.real/16);
 for(let y=0;y<old.oh;y+=tileR)for(let x=0;x<old.ow;x+=old.internalWidth){
  const nr=Math.min(tileR,old.oh-y),nc=Math.min(old.internalWidth,old.ow-x);
  rowWaves+=nr+1;packets+=nr*nc*validOB;tiles++;
  const ny=x+old.internalWidth<old.ow?y:y+tileR;
  const nextNR=ny<old.oh?Math.min(tileR,old.oh-ny):0;
  if(pointwise)prefetchDrainRows+=Math.max(0,(nextNR-nr-1)*(old.ic/4));
 }
 if(tiles!==old.tiles)throw Error('Tile count mismatch');
 return{op:old.op,k:old.k,ic:old.ic,oc:old.oc,ocReal:old.real,pointwise,
  internalWidth:old.internalWidth,tiles,computeBlocks:old.blocks,
  oldWaves:old.blocks+2*tiles,newWaves:pointwise?rowWaves:old.blocks+2*tiles,
  expectedPackets:pointwise?packets:0,prefetchDrainRows,
  effectiveInputWords:old.afterWords};
});
const fast=ops.filter(o=>o.pointwise),sum=(a,k)=>a.reduce((n,o)=>n+o[k],0);
if(fast.length!==43||sum(fast,'prefetchDrainRows')!==0)throw Error('Unexpected model coverage/drain');
const result={version:'R6.4 / 10.xsa',kind:'source descriptor geometry; not measured performance',
 pointwiseOps:fast.length,pointwiseOldWaves:sum(fast,'oldWaves'),pointwiseNewWaves:sum(fast,'newWaves'),
 pointwisePackets:sum(fast,'expectedPackets'),inputWords:sum(ops,'effectiveInputWords'),
 extraPointwisePrefetchDrainRows:sum(fast,'prefetchDrainRows'),ops};
fs.writeFileSync(path.join(root,'yolov5n_hls_r6_4_20261016/r6_4_geometry.json'),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify({...result,ops:undefined},null,2));
