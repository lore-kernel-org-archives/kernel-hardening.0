Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 12 Jan 2017 08:18:47 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3C452@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org>
 <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKDYE7AHrXchNDLmvNMbvGytZDks6W1=i6+fyFX9ZGoNA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3BD08@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com>
 <CAGXu5jLC-drraZ3D5bj3_rO4LEFiUhutHHw7U8AfDyAEHg+xtg@mail.gmail.com>,<20170112051114.GG20972@linaro.org>
In-Reply-To: <20170112051114.GG20972@linaro.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 11, 2017 at 02:55:21PM -0800, Kees Cook wrote:=0A=
> On Wed, Jan 11, 2017 at 1:42 PM, Kees Cook <keescook@chromium.org> wrote:=
=0A=
> > I can see if it'll cherry-pick cleanly, I assume it will. :)=0A=
>=0A=
> It cherry-picked cleanly. However, I made several changes:=0A=
>=0A=
> - I adjusted Peter's author email (it had extra []s around).=0A=
> - I fixed all of the commit subjects (Peter's were missing).=0A=
> - I added back "kref: Add KREF_INIT()" since it seems to have been=0A=
> lost and mixed into other patches that would break bisection=0A=
>=0A=
> It's here now, please work from this version:=0A=
>=0A=
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dkspp/=
hardened-atomic=0A=
=0A=
>I gave it a spin on arm64.=0A=
>It can compile with a change to smp.c that I mentioned before,=0A=
>but the boot failed. I've not dug into it.=0A=
=0A=
Thank you! I fixed the smp.c (https://github.com/ereshetova/linux-stable/tr=
ee/refcount_t), I am surprised there was nothing more, I was expecting it t=
o be worse. =0A=
With regards to below error, I am afraid there are more of them to come sin=
ce it really breaks things badly if there is a place that attempts to incre=
ment from zero. The way we have been debugging this is to modify the refcou=
nt_inc implementation to do the increment from zero, but just issue a warni=
ng (as in the first Peter's patch series) and then boot, collect all warnin=
gs from dmesg and process them manually one by one. =0A=
If you could boot once with just warnings and send us all of refcount_t occ=
urrences, we can try to see/fix them. The same would need to be done for ar=
m also and for other archs. =0A=
=0A=
Best Regards,=0A=
Elena.=0A=
=0A=
=3D=3D=3D8<=3D=3D=3D=0A=
[    3.578618] refcount_t: increment on 0; use-after-free.=0A=
[    3.579165] ------------[ cut here ]------------=0A=
[    3.579254] WARNING: CPU: 0 PID: 1 at /home/akashi/arm/armv8/linaro/linu=
x-aarch64/include/linux/refcount.h:109 unx_create+0x8c/0xc0=0A=
[    3.579338] Modules linked in:=0A=
[    3.579388]=0A=
[    3.579444] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.10.0-rc2-00018-g=
9a56ff6b34bd-dirty #1=0A=
[    3.579518] Hardware name: FVP Base (DT)=0A=
[    3.579578] task: ffff80087b078000 task.stack: ffff80087b080000=0A=
[    3.579655] PC is at unx_create+0x8c/0xc0=0A=
[    3.579722] LR is at unx_create+0x8c/0xc0=0A=
[    3.579786] pc : [<ffff0000088c9c24>] lr : [<ffff0000088c9c24>] pstate: =
60000145=0A=
[    3.579855] sp : ffff80087b0837c0=0A=
[    3.579906] x29: ffff80087b0837c0 x28: 0000000000000000=0A=
[    3.579988] x27: ffff000008940bd0 x26: ffff000008e026fd=0A=
[    3.580073] x25: ffff000008f3b000 x24: ffff000008f3be98=0A=
[    3.580158] x23: ffff80087a750200 x22: ffff000008f3b000=0A=
[    3.580243] x21: ffff000008a57b48 x20: ffff80087b083860=0A=
[    3.580328] x19: ffff000008ed4000 x18: 0000000000000010=0A=
[    3.580409] x17: 0000000000000007 x16: 0000000000000001=0A=
[    3.580492] x15: ffff000088ee8ff7 x14: 0000000000000006=0A=
[    3.580575] x13: ffff000008ee9005 x12: ffff000008e10958=0A=
[    3.580660] x11: ffff000008e10000 x10: ffff000008517ff0=0A=
[    3.580745] x9 : ffff000008db5000 x8 : 2d657375203b3020=0A=
[    3.580830] x7 : 6e6f20746e656d65 x6 : 0000000000000100=0A=
[    3.580913] x5 : ffff000008eeac90 x4 : 0000000000000000=0A=
[    3.580993] x3 : 0000000000000000 x2 : 0000000000000463=0A=
[    3.581076] x1 : ffff80087b078000 x0 : 000000000000002b=0A=
[    3.581150]=0A=
[    3.581191] ---[ end trace f4a7848050409b47 ]---=0A=
[    3.581241] Call trace:=0A=
[    3.581300] Exception stack(0xffff80087b0835f0 to 0xffff80087b083720)=0A=
[    3.581384] 35e0:                                   ffff000008ed4000 000=
1000000000000=0A=
[    3.581489] 3600: ffff80087b0837c0 ffff0000088c9c24 ffff000008bb1588 fff=
f000008db5000=0A=
[    3.581593] 3620: ffff000008eeac90 ffff000008ea2fe0 ffff000008ee8ff8 000=
000010000002b=0A=
[    3.581699] 3640: ffff80087b0836e0 ffff00000810cea0 ffff000008ed4000 fff=
f80087b083860=0A=
[    3.581803] 3660: ffff000008a57b48 ffff000008f3b000 ffff80087a750200 fff=
f000008f3be98=0A=
[    3.581907] 3680: ffff000008f3b000 ffff000008e026fd 000000000000002b fff=
f80087b078000=0A=
[    3.582006] 36a0: 0000000000000463 0000000000000000 0000000000000000 fff=
f000008eeac90=0A=
[    3.582109] 36c0: 0000000000000100 6e6f20746e656d65 2d657375203b3020 fff=
f000008db5000=0A=
[    3.582214] 36e0: ffff000008517ff0 ffff000008e10000 ffff000008e10958 fff=
f000008ee9005=0A=
[    3.582313] 3700: 0000000000000006 ffff000088ee8ff7 0000000000000001 000=
0000000000007=0A=
[    3.582405] [<ffff0000088c9c24>] unx_create+0x8c/0xc0=0A=
[    3.582484] [<ffff0000088c9050>] rpcauth_create+0xc8/0x120=0A=
[    3.582567] [<ffff0000088be3c8>] rpc_client_register+0xc8/0x148=0A=
[    3.582652] [<ffff0000088be5cc>] rpc_new_client+0x184/0x278=0A=
[    3.582736] [<ffff0000088bf18c>] rpc_create_xprt+0x4c/0x168=0A=
[    3.582819] [<ffff0000088bf384>] rpc_create+0xdc/0x1a8=0A=
[    3.582907] [<ffff0000082eda54>] nfs_mount+0xb4/0x168=0A=
[    3.582988] [<ffff0000082e3f48>] nfs_request_mount.constprop.14+0xa8/0x1=
00=0A=
[    3.583075] [<ffff0000082e3ff8>] nfs_try_mount+0x58/0x238=0A=
[    3.583154] [<ffff0000082e38c8>] nfs_fs_mount+0x270/0x848=0A=
[    3.583240] [<ffff0000081f1cf4>] mount_fs+0x4c/0x168=0A=
[    3.583330] [<ffff00000820eb60>] vfs_kern_mount+0x50/0x118=0A=
[    3.583407] [<ffff0000082115dc>] do_mount+0x1ac/0xbc0=0A=
[    3.583483] [<ffff000008212410>] SyS_mount+0x90/0xf8=0A=
[    3.583572] [<ffff000008cf12a4>] mount_root+0x74/0x134=0A=
[    3.583664] [<ffff000008cf14a0>] prepare_namespace+0x13c/0x184=0A=
[    3.583758] [<ffff000008cf0d94>] kernel_init_freeable+0x224/0x248=0A=
[    3.583842] [<ffff0000088f27d0>] kernel_init+0x10/0x100=0A=
[    3.583921] [<ffff000008082ec0>] ret_from_fork+0x10/0x50=0A=
[    3.584149] refcount_t: increment on 0; use-after-free.=0A=
[    3.584695] ------------[ cut here ]------------=0A=
[    3.584784] WARNING: CPU: 0 PID: 1 at /home/akashi/arm/armv8/linaro/linu=
x-aarch64/include/linux/refcount.h:109 unx_create+0x8c/0xc0=0A=
< repeated ... >=0A=
=0A=
=3D=3D=3D>8=3D=3D=3D=0A=
Here, I used an NFS rootfs.=0A=
=0A=
Thanks,=0A=
-Takahiro AKASHI=0A=
=0A=
> 0-day should see it soon. :)=0A=
>=0A=
> -Kees=0A=
>=0A=
> --=0A=
> Kees Cook=0A=
> Nexus Security=0A=
