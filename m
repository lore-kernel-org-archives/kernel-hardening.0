Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 14:28:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20160119112812.GA10818@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] 2015 kernel CVEs
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I like to look back over old CVEs to see how we could do better.  Here
is the list from 2015.  I got most of this information from the Ubuntu
CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
might not be fixed yet.

CVE-2015-5707 451a2886b6bf fdc81f45e9f5: scsi/sg: integer overflow leading to buffer overflow (iovec)
CVE-2015-5257 cbb4be652d37: usb/whiteheat: NULL deref with bad hardware.
CVE-2015-6252 7932c0bd7740: vhost: resource leak. DoS
CVE-2015-5366 beb39db59d14: udp: not yielding the CPU. DoS udp: duplicate of CVE-2015-5366?
CVE-2015-4700 3f7352bf21f8: bpf: NULL deref on corner case.
CVE-2015-7872 f05819df10d7: keys: uninitialized data
CVE-2015-4178 820f9f147dcc: fs_pin: uninitialized data
CVE-2015-4002 d114b9fe78c8 9a59029bc218: staging/ozwpan: buffer overflow
CVE-2015-7799 0baa57d8dc32 4ab42d78e37a: ppp: bad bounds check leads to NULL deref. (root only normally).
CVE-2015-3290 9b6e6a8334d5: nmi: nested NMI is problematic
CVE-2015-2041 6b8d9117ccb4: net: llc: bounds error leads to info leak
CVE-2015-4003 04bf464a5dfd: staging/ozwpan: divide by zero
CVE-2015-3331 ccfe8c3f7e52: crypto/aesni: buffer overflow because of math error
CVE-2015-4001 b1bb5b49373b: staging/ozwpan: array underflow write
CVE-2015-6526 9a5cbce421a2: powerpc/perf: forever loop
CVE-2015-0239 f3747379accb: KVM: x86: uninitialized data
CVE-2015-4176 e0c9c0afd2fc: mnt: flaw in logic
CVE-2015-2150 af6fc858a35b: xen-pciback: accidentally gave too much power
CVE-2015-3339 : fs: race condition between chown and execve
CVE-2015-2830 956421fbb74c: x86/asm/entry/64: faw in assembly logic
CVE-2015-4692 ce40cd3fc7fa: kvm: x86: NULL deref
CVE-2015-4170 cf872776fc84: tty: hang in tty
CVE-2015-1350 : fs: some attributes are managed by chown some by the lsm
CVE-2015-0275 0f2af21aae11: ext4: BUG() alignment issue when page size larger than block size
CVE-2015-5706 f15133df088e: path_openat: double free
CVE-2015-4177 cd4a40174b71: mnt: flaw in logic with namespaces (crash I guess).
CVE-2015-6937 74e98eb08588: RDS: NULL deref
CVE-2015-2925 cde93be45a8a 397d425dc26d: vfs: logic flaw handling path names
CVE-2015-3636 a134f083e79f: ipv4: use after free leads to NULL deref
CVE-2015-2877 : kvm: ASLR base address leak of co-located VMs.
CVE-2013-2015 0e9a9a1ad619: ext4: hang during mount
CVE-2015-5157 9b6e6a8334d5: x86/nmi/64: nested NMI problems
CVE-2015-1420 161f873b8913: vfs: bounds checking error leads to serious info leak
CVE-2015-1421 600ddd682554: net/sctp: double free
CVE-2015-7613 b9a532277938: ipc/msg: uninitialized data
CVE-2015-4004 a73e99cb67e7: staging/ozwpan: we just deleted the driver
CVE-2015-3212 2d45a02d0166: net/sctp: race condition
CVE-2015-3291 810bc075f78f: x86/nmi/64: more nested NMI issues
CVE-2015-4167 23b133bdc452: fs/udf: trusting the disk (missing range checks)
CVE-2015-1805 f0d1bec9d58d 637b58c2887e: fs/pipe: bad error handling leads to buffer overflow
CVE-2015-1333 ca4da5dd1f99: keys: memory leak
CVE-2015-2042 db27ebb111e9: net/rds: using wrong bounds leads to info leak
CVE-2015-5283 8e2d61e0aed2: net/sctp: uninitialized data. life cycle issues.
CVE-2015-5697 b6878d9e0304: md: not zeroing memory from kmalloc() leads to info leak
CVE-2015-5364 beb39db59d14: udp: duplicate of CVE-2015-5366?
CVE-2015-4036 59c816c1f24d: vhost/scsi: wrong bounds limit
CVE-2015-5156 48900cb6af42: virtio-net: logic flaw leads to buffer overflow
CVE-2015-2922 6fd99094de2b: ipv6: logic flaw leads to dropped packets
CVE-2015-1593 4e7c22d447bb: ASLR: shift truncation leads to not enough ASLR
CVE-2015-1573 a2f18db0c68f: netfilter/nf_tables: use after free
CVE-2015-2686 4de930efc23b: net: missing access_ok() checks
CVE-2015-2672 06c8173eb92b: x86/fpu/xsaves: logic flaw in assembly leads to DoS
CVE-2015-1465 df4d92549f23: ipv4: logic flaw with RCU leading to DoS
CVE-2015-2666 f84598bd7c85: x86/microcode/intel: missing bounds check verifying microcode
CVE-2015-0274 8275cdd0e7ac: xfs: using wrong bounds
CVE-2015-8215 77751427a1ff: ipv6: setting wrong mtu causes packet loss
CVE-2015-7885 4b6184336ebb: staging/dgnc: info leak
CVE-2015-7884 eda98796aff0: media/vivid: info leak
CVE-2015-7509 c9b92530a723 0e9a9a1ad619: ext4: hang on mount
CVE-2015-8575 : net/bluetooth: still private
CVE-2015-7513 0185604c2d82: KVM: uninitialized data leads to mod by zero
CVE-2015-8324 744692dc0598: ext4: NULL deref mounting file systems
CVE-2015-5307 54a20552e1ea: KVM: forever loop
CVE-2015-7550 b4a1b4f5047e: KEYS: Race condition
CVE-2015-8569 09ccfd238e5a: pptp: underflow leads to serious information leak
CVE-2015-8660 acff81ec2c79: ovl: logic flaw in checking permisions
CVE-2015-8374 0305cd5f7fca: Btrfs: logic flaw in truncate leads to information leak
CVE-2015-8539 096fe9eaea40: Keys: uninitialized data leads to bad dereference
CVE-2015-8709 : ptrace: race in user namespaces let's users trace root processes
CVE-2015-8746 18e3b739fdc8: NFS: NULL deref. missing function pointer.
CVE-2015-8104 cbdb967af3d5: kvm: guest can make the host hang
CVE-2015-8767 635682a14427: sctp: lockup
CVE-2015-7990 8c7188b23474: RDS: race condition leads to NULL deref
CVE-2015-5327 cc25b994acfb: X.509: off by one read leads to badness
CVE-2015-8543 79462ad02e86: ipv4: bad range checking leads to NULL deref

There are several ways that CVEs are assigned.  The person who discovers
the bug can get it from oss-security.  If bugs are reported to
security@kernel.org they get forwarded to linux-distros who allocates a
CVE.  Distributions look through the stable patches and file for CVEs.
A few maintainers apply for CVEs, notably the KVM devs and I think David
Howells.

There was only a coupls CVEs that looks like they came from a filesystem
fuzzer where you create a corrupt filesystems and then try use them.
There was only one that might have come from a USB fuzzer.  We probably
should be testing those things better.

There was one CVE from Smatch.  Smatch has improved, inspired by the
ozwpan bugs and hopefully could catch most of those bounds errors now.

Quite a few bugs were found using the Trinity fuzzer.  Also the new
syzkaller fuzzer seems to have found a bunch of stuff.  Good work.  I
think people are using the fuzzers with kasan as well which is a
fantastic tool.

Many of the use-after-free and unintialized data bugs would be less
harmful if we had some kernel hardenning patches.

A lot of the bugs are just really complicated things with funny corner
cases, namespace issues or people just made mistake in the logic and
it's hard to do anything about it.

regards,
dan carpenter
