Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAOLZvyEiOasozPb8ZBpNjcoUjOsrR+cGhc0hJxz8KAdNgNdHOA@mail.gmail.com>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
	<CAOLZvyEiOasozPb8ZBpNjcoUjOsrR+cGhc0hJxz8KAdNgNdHOA@mail.gmail.com>
Date: Wed, 3 Aug 2011 10:00:06 +0200
Message-ID: <CAOLZvyE2Ng-VPPv68_NF0NP-vqW2FofSrBWjATNX88VH5yvZ-w@mail.gmail.com>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 3, 2011 at 9:50 AM, Manuel Lauss
<manuel.lauss@googlemail.com> wrote:
> On Wed, Aug 3, 2011 at 9:43 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Tue, Aug 2, 2011 at 2:45 AM, Vasiliy Kulikov <segoon@openwall.com> wr=
ote:
>>>
>>> From: Vasiliy Kulikov <segoon@openwall.com>
>>> Subject: [PATCH] shm: fix a race between shm_exit() and shm_init()
>>
>> This patch is disgusting.
>>
>> Doing things like this:
>>
>>> + =A0 =A0 =A0 /*
>>> + =A0 =A0 =A0 =A0* For init_ipc_ns shm_ids().rw_mutex is statically ini=
tialized
>>> + =A0 =A0 =A0 =A0* as kernel threads should be able to use it in do_exi=
t() before
>>> + =A0 =A0 =A0 =A0* shm_init(), which is called on do_initcall()
>>> + =A0 =A0 =A0 =A0*/
>>> + =A0 =A0 =A0 if (ns =3D=3D &init_ipc_ns)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __ipc_init_ids(&shm_ids(ns));
>>> + =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ipc_init_ids(&shm_ids(ns));
>>
>> should have told you that there is something totally wrong with your pat=
ch.
>>
>> I'd prefer to really do the initialization in the allocator (at which
>> point it would be very natural to do the initialization statically for
>> a static allocation, and you wouldn't have the above kind of nasty
>> conditional stuff), but that whole namespace initialization and setup
>> just looks pretty nasty.
>>
>> Looking at some of the other cases like net_ns_init(), maybe the
>> proper fix is to just make 'ipc_ns_init()' be a pure_initcall().
>>
>> Does the attached patch work?
>
> No, same oops still.

Your new initcall comes right AFTER the oops:

Mount-cache hash table entries: 512
CPU 0 Unable to handle kernel paging request at virtual address
00000000, epc =3D=3D 8030b2bc, ra =3D=3D 80206ba0
Oops[#1]:
Cpu 0
$ 0   : 00000000 10003c00 00000000 10003c01
$ 4   : 80379644 83c41e88 80379648 83c37520
$ 8   : 00000000 01312d00 0016e35f 83c3f01c
$12   : 83c09f08 83c09f10 00000001 00000780
$16   : 83c37520 00000000 00000000 00000000
$20   : 00000000 00000000 00000000 00000000
$24   : 00000000 8011fbec
$28   : 83c40000 83c41e78 00000000 80206ba0
Hi    : 00000000
Lo    : 01312d00
epc   : 8030b2bc __down_write_nested+0x68/0xf0
    Not tainted
ra    : 80206ba0 exit_shm+0x24/0x54
Status: 10003c02    KERNEL EXL
Cause : 0080800c
BadVA : 00000000
PrId  : 01030200 (Au1500)
Process kworker/u:0 (pid: 9, threadinfo=3D83c40000, task=3D83c37520, tls=3D=
00000000)
Stack : ffffffff ffffffff 00000000 ffffffff 80379648 00000000 83c37520 0000=
0002
        ffffffff 80379644 00000000 80206ba0 00000000 00000000 00000000 0000=
0000
        803795f0 00000000 83c37520 80128ebc 83c40000 83c41ef0 ffffffff 8013=
a8a8
        00000001 ffffffff 83c2ac80 83c2ac80 83c16300 8013a8b4 ffffffff ffff=
ffff
        ffffffff ffffffff ffffffff ffffffff ffffffff 00000000 00000000 8010=
5b1c
        ...
Call Trace:
[<8030b2bc>] __down_write_nested+0x68/0xf0
[<80206ba0>] exit_shm+0x24/0x54
[<80128ebc>] do_exit+0x1a4/0x254
[<8013a8b4>] ____call_usermodehelper+0xfc/0x118
[<80105b1c>] kernel_thread_helper+0x10/0x18


Code: ac850008  afa60010  afa20014 <ac450000> 40016000  30630001
3421001f  3821001f  00611825
Disabling lock debugging due to kernel taint
Fixing recursive fault but reboot is needed!
calling  ipc_ns_init+0x0/0x4c @ 1
initcall ipc_ns_init+0x0/0x4c returned 0 after 0 usecs
calling  init_mmap_min_addr+0x0/0x18 @ 1
initcall init_mmap_min_addr+0x0/0x18 returned 0 after 0 usecs
calling  init_atomic64_lock+0x0/0x8 @ 1

Manuel
