Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110802135512.b49c9de1.akpm@linux-foundation.org>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<20110802135512.b49c9de1.akpm@linux-foundation.org>
Date: Wed, 3 Aug 2011 07:30:52 +0200
Message-ID: <CAOLZvyErAWMmJoSNw5Bicycc3CByWW024Azp8OL6zHHH-QQH1g@mail.gmail.com>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2011 at 10:55 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 2 Aug 2011 16:45:30 +0400
> Vasiliy Kulikov <segoon@openwall.com> wrote:
>
>> On thread exit shm_exit() is called, it uses shm_ids(ns).rw_mutex.
>> It is initialized in shm_init(), but it is not called yet at the moment
>> of kernel threads exit. =C2=A0Some kernel threads are created in
>> do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().
>>
>> Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.
>>
>> It fixes a kernel oops:
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 0000=
0000
>> ...
>> [<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>] (exit_shm=
+0x28/0x48)
>> [<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>] (do_exit+0x59c/0x750=
)
>> [<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>] (____call_usermodeh=
elper+0x13c/0x154)
>> [<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>] (ke=
rnel_thread_exit+0x0/0x8)
>
> erm, wait. =C2=A0There's no reason I can think of why a kernel thread nee=
ds
> to call shm_exit() at all?
>
> Is that a regular kernel thread exiting, or is it a
> call_usermodehelper() worker thread? =C2=A0It *looks* like
> ____call_usermodehelper()'s kernel_execve() failed, so
> ____call_usermodehelper() directly called do_exit().
>
> Something's still screwed up here - we shouldn't be trying to run
> usermode helper applications before shm_init() has been run - usermode
> helpers can use ipc!
>
> Can someone who can reproduce this please work out if and why we're
> calling call_usermodehelper() under do_pre_smp_initcalls()? =C2=A0Somethi=
ng
> like this...

I applied your test patch, but it didn't print anything new (it's a
single-cpu system).


Linux version 3.0.0-db1200-07143-g9c8749b (mano@flagship) (gcc version
4.5.2 (Gentoo 4.5.2 p1.1) ) #14 Wed Aug 3 07:23:37 CEST 2011
CPU revision is: 04030202 (Au1250)
(PRId 04030202) @ 696.00 MHz
Alchemy/AMD/RMI DB1200 Board, CPLD Rev 2  Board-ID 12  Daughtercard ID 15
Determined physical RAM map:
 memory: 10000000 @ 00000000 (usable)
Zone PFN ranges:
  Normal   0x00000000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00010000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat 806cc1a0, node_mem_map 81000000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65024 pages, LIFO batch:15
pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line:  root=3D/dev/hda1 rootfstype=3Dext2 console=3Dtty
console=3DttyS0,115200 video=3Dau1200fb:panel:bs
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Primary instruction cache 16kB, VIPT, 4-way, linesize 32 bytes.
Primary data cache 16kB, 4-way, VIPT, no aliases, linesize 32 bytes
Memory: 252456k/262144k available (4839k kernel code, 9688k reserved,
1098k data, 200k init, 0k highmem)
NR_IRQS:128
Alchemy clocksource installed
Console: colour dummy device 80x25
console [tty0] enabled
Calibrating delay loop (skipped) preset value.. 696.00 BogoMIPS (lpj=3D3480=
000)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU 0 Unable to handle kernel paging request at virtual address
00000000, epc =3D=3D 805b86ec, ra =3D=3D 802a6f1c
Oops[#1]:
Cpu 0
$ 0   : 00000000 10003c00 00000000 10003c01
$ 4   : 806b6584 8fc45e60 806b6588 8fc3f520
$ 8   : 00000000 00000000 0016e35f 00000000
$12   : 00000080 00000010 00000010 8fc3001c
$16   : 8fc3f520 00000000 00000000 00000000
$20   : 00000000 00000000 8fc45eb4 00000000
$24   : 00000000 8011ef30
$28   : 8fc44000 8fc45e50 00000001 802a6f1c
Hi    : 00000000
Lo    : 00000000
epc   : 805b86ec __down_write_nested+0x68/0xf0
    Not tainted
ra    : 802a6f1c exit_shm+0x24/0x54
Status: 10003c02    KERNEL EXL
Cause : 0080800c
BadVA : 00000000
PrId  : 04030202 (Au1250)
Process kworker/u:0 (pid: 9, threadinfo=3D8fc44000, task=3D8fc3f520, tls=3D=
00000000)
Stack : 00000000 00000000 00000000 00000000 806b6588 00000000 8fc3f520 0000=
0002
        8fc2c000 806b6584 00000000 802a6f1c 00000000 00000000 00000000 0000=
0000
        806b6530 00000000 8fc3f520 801280b8 04000200 00040000 00000000 0000=
8000
        00000000 00000000 40000000 00000000 00000000 00000000 8fc28ca0 8fc1=
53a0
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 8013=
8b68
        ...
Call Trace:
[<805b86ec>] __down_write_nested+0x68/0xf0
[<802a6f1c>] exit_shm+0x24/0x54
[<801280b8>] do_exit+0x50c/0x664
[<80138b68>] ____call_usermodehelper+0xfc/0x118
[<8010573c>] kernel_thread_helper+0x10/0x18


Code: ac850008  afa60010  afa20014 <ac450000> 40016000  30630001
3421001f  3821001f  00611825
Disabling lock debugging due to kernel taint
Fixing recursive fault but reboot is needed!
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource alchemy-counter1
Switched to NOHz mode on CPU #0
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
DB1200 device configuration:
 S6.8 OFF: PSC0 mode I2C
   OTG port VBUS supply available!
 S6.7 OFF: PSC1 mode AC97
audit: initializing netlink socket (disabled)
type=3D2000 audit(0.120:1): initialized
squashfs: version 4.0 (2009/01/31) Phillip Lougher
Registering the id_resolver key type
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
JFFS2 version 2.2. (NAND) (SUMMARY)  =E2=94=AC=C2=AE 2001-2006 Red Hat, Inc=
.
msgmni has been set to 493
NET: Registered protocol family 38
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered (default)
au1200fb: LCD controller driver for AU1200 processors
au1200fb: Panel 5 Samsung_1024x768_TFT
au1200fb: Win 2 0-FS gfx, 1-video, 2-ovly gfx, 3-ovly gfx
Panel(Samsung_1024x768_TFT), 1024x768
[...]
Manuel
