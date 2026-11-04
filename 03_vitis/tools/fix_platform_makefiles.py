# -*- coding: utf-8 -*-
"""
Vitis 平台 Makefile 一键修复 (Vitis/Vivado 2020.2 on Windows)
=============================================================
治两个"由工具自动生成、每换一次 XSA 都会复发"的缺陷:

  A) HLS 导出 IP 的驱动 Makefile 里有 Tab 缩进的 `#echo "..."` 行。
     sh 下它是注释; 但 Vitis 的 BSP 构建用 cmd 执行 recipe -> `#echo` 被当命令 ->
     CreateProcess failed -> "make[2]: *** [Makefile:40: ...] Error 2"
     -> IDE 报 "Failed to build the bsp sources for domain ..." / "Failed to build the zynq_fsbl application".
     文件由 Vitis HLS 生成并打进 IP/XSA, Vitis 只是原样复制:
         <hls>/solution1/impl/ip/drivers/<drv>/src/Makefile
         -> <vivado>/ip_repo/.../drivers/...            (打包进 .xsa)
         -> <platform>/hw/drivers/<drv>/src/Makefile    (platform generate 每次都从 XSA 重新解包,
                                                         实测会覆盖手改 -> 改这里不算"永久")
         -> <platform>/**/libsrc/<drv>/src/Makefile     (BSP 重生成时从上一步复制)
     => 唯一"修一次就永久"的位置是 XSA 本身(或进 XSA 之前的 ip_repo)。

  B) generate_app 生成的 FSBL 应用 Makefile 的 clean 规则多一个裸通配:
         rm -rf $(OBJS) $(LIBS) $(EXEC) *.o
     目录里没有 .o 时(新建平台 / 刚 clean 过)通配符不展开, Xilinx gnuwin 的 rm.exe
     对字面量 `*.o` 报 EINVAL -> "make: *** [Makefile:42: clean] Error 1" -> IDE "Failed to do platform clean".

用法
----
  python fix_platform_makefiles.py                     # 自动找 03_vitis 下的 *_platform, 修平台 + 其 hw/*.xsa
  python fix_platform_makefiles.py <platform_dir>
  python fix_platform_makefiles.py --xsa <file.xsa>    # 只修一个 XSA (Vivado 刚导出的那个, 导入 Vitis 前跑)
  python fix_platform_makefiles.py --dir <dir>         # 递归修一个目录 (HLS 的 impl/ip、ip_repo)
  追加 --dry 只列出会改哪些文件, 不落盘。

幂等: 修过的文件再跑不会重复改。XSA 修改前自动留 .bak。
"""
import os
import re
import sys
import glob
import zipfile
import shutil

ECHO_RE = re.compile(rb'^[ \t]*#echo[ \t]')
CLEAN_RE = re.compile(rb'(rm -rf \$\(OBJS\) \$\(LIBS\) \$\(EXEC\)) \*\.o')


def fix_makefile_bytes(raw):
    """返回 (新内容, 删掉的 #echo 行数, clean 规则是否被修)"""
    eol = b'\r\n' if b'\r\n' in raw else b'\n'
    kept, removed = [], 0
    for ln in raw.replace(b'\r\n', b'\n').split(b'\n'):
        if ECHO_RE.match(ln):
            removed += 1
            continue
        kept.append(ln)
    new = eol.join(kept)
    new, n_clean = CLEAN_RE.subn(rb'\1', new)
    return new, removed, n_clean


def fix_makefile_on_disk(path, dry=False):
    raw = open(path, 'rb').read()
    new, n_echo, n_clean = fix_makefile_bytes(raw)
    changed = (n_echo > 0) or (n_clean > 0)      # 只在真删到/改到东西时才落盘
    if changed and not dry:
        open(path, 'wb').write(new)
    return n_echo, n_clean, changed


def _norm(name):
    return name.replace('\\', '/')


def _is_driver_makefile(name):
    n = _norm(name)
    return n.endswith('/src/Makefile') and (n.startswith('drivers/') or '/drivers/' in n)


def fix_tree(root, dry=False):
    touched = 0
    for f in sorted(glob.glob(os.path.join(root, '**', 'Makefile'), recursive=True)):
        n_echo, n_clean, changed = fix_makefile_on_disk(f, dry)
        if changed:
            print('  [%sfix] %s   (#echo x%d, clean-rule x%d)'
                  % ('DRY ' if dry else '', f, n_echo, n_clean))
            touched += 1
    return touched


def fix_xsa(path, dry=False, backup=True):
    """XSA 本质是 zip: 原地重写, 只替换 drivers/*/src/Makefile 的内容"""
    zin = zipfile.ZipFile(path, 'r')
    bad = zin.testzip()
    if bad:
        raise RuntimeError('XSA corrupt: %s' % bad)
    infos = zin.infolist()
    plan = []
    for i in infos:
        if not _is_driver_makefile(i.filename):
            continue
        data = zin.read(i.filename)
        new, n_echo, n_clean = fix_makefile_bytes(data)
        if n_echo or n_clean:
            plan.append((i.filename, new, n_echo, n_clean))
    if not plan:
        print('  (clean already: %s)' % path)
        zin.close()
        return 0
    for name, _, n_echo, n_clean in plan:
        print('  [%sfix] %s :: %s   (#echo x%d, clean-rule x%d)'
              % ('DRY ' if dry else '', os.path.basename(path), name, n_echo, n_clean))
    if dry:
        zin.close()
        return len(plan)
    tmp = path + '.tmp_fix'
    if backup and not os.path.exists(path + '.bak'):
        shutil.copy2(path, path + '.bak')
    with zipfile.ZipFile(tmp, 'w') as zout:
        replace = {name: data for name, data, _, _ in plan}
        for i in infos:
            data = replace.get(i.filename)
            if data is None:
                data = zin.read(i.filename)
            zout.writestr(i, data)
    zin.close()
    os.replace(tmp, path)
    return len(plan)


def find_platform():
    here = os.path.dirname(os.path.abspath(__file__))
    ws = os.path.dirname(here)
    cands = [d for d in glob.glob(os.path.join(ws, '*_platform'))
             if os.path.exists(os.path.join(d, 'platform.spr'))]
    if len(cands) == 1:
        return cands[0]
    if len(cands) > 1:
        print('multiple platforms found, pass one explicitly:')
        for c in cands:
            print('   ' + c)
    return None


def main(argv):
    dry = '--dry' in argv
    args = [a for a in argv[1:] if a != '--dry']
    if '--xsa' in args:
        for x in args[args.index('--xsa') + 1:]:
            print('[XSA] %s' % x)
            fix_xsa(x, dry)
        return 0
    if '--dir' in args:
        for d in args[args.index('--dir') + 1:]:
            print('[DIR] %s' % d)
            fix_tree(d, dry)
        return 0
    plat = args[0] if args else find_platform()
    if not plat or not os.path.isdir(plat):
        print('platform dir not found; pass <platform_dir> explicitly')
        return 2
    print('[PLATFORM] %s' % plat)
    n = fix_tree(plat, dry)
    for xsa in sorted(glob.glob(os.path.join(plat, 'hw', '*.xsa'))):
        fix_xsa(xsa, dry)
    print('done: %d Makefile(s) touched%s' % (n, '   (DRY RUN, nothing written)' if dry else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
