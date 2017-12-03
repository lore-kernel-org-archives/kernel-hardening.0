Date: Sun, 3 Dec 2017 19:19:53 +0200
From: Dan Aloni <dan@kernelim.com>
Message-ID: <20171203171953.GB17575@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] Use-after-free with deferred driver probing and __initconst
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Thomas Garnier <thgarnie@google.com>, Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, Grant Likely <grant.likely@secretlab.ca>, Rob Herring <robh+dt@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

[[ CC'ed: folks relating to the original __*_refok family of attributes,
deferred probing, Open Firmware maintainer, drivers/base/ maintainer,
kernel harderning, LKML ]]

It seems that it is possible to cause a use-after-free in the base driver
platform code using a set of combined circumstances which I describe below.
The instance of the issue happens on a patched 4.4 kernel at a client of
mine.

[    6.173692] Process kworker/u12:3 (pid: 173, stack limit = 0xfffffc3ea92b8000)
[    6.180902] Call trace:
[    6.183345] [<ffff12bbcd90746c>] __of_match_node+0x48/0x8c
[    6.188820] [<ffff12bbcd9074f4>] of_match_node+0x44/0x68
[    6.194125] [<ffff12bbcd9097e4>] of_match_device+0x34/0x48
[    6.199603] [<ffff12bbcd4e1ed8>] platform_match+0x34/0xa8
[    6.204991] [<ffff12bbcd4df3c0>] __device_attach_driver+0x60/0xc8
[    6.211077] [<ffff12bbcd4dca38>] bus_for_each_drv+0x60/0xac
[    6.216640] [<ffff12bbcd4ded40>] __device_attach+0x98/0x124
[    6.222203] [<ffff12bbcd4df494>] device_initial_probe+0x24/0x30
[    6.228111] [<ffff12bbcd4ddf4c>] bus_probe_device+0x38/0xa0
[    6.233677] [<ffff12bbcd4de57c>] deferred_probe_work_func+0x108/0x128
[    6.240111] [<ffff12bbcced1d50>] process_one_work+0x268/0x444
[    6.245849] [<ffff12bbcced21a0>] worker_thread+0x274/0x404
[    6.251329] [<ffff12bbcced8c28>] kthread+0xe0/0xe8
[    6.256114] [<ffff12bbcce92740>] ret_from_fork+0x10/0x50
[    6.261415] ---[ end trace fccad0f7d2c2142a ]---
[    6.271293] note: kworker/u12:3[173] exited with preempt_count 1
[    6.277342] Unable to handle kernel paging request at virtual address ffffffffffffffd8

It happens while booting, and among other things it requires having platform
OF drivers marking their `of_driver_id` arrays as `__initconst`, e.g:

    static const struct of_device_id some_driver_of[] __initconst = {
        ...
        {},
    };

Given a platform driver that uses deferred probing, these arrays marked as
`__initconst` could be accessed from a deferred probe path after the init
section of the kernel has been freed. I have not seen anything in the API
related deferred probing that can guard from this scenario.

On kernels prior to KASLR the access is not detected, but it can still happen,
potentially accessing memory that was returned to the page allocator.

On 4.15-rc1, the following shows the ratio between instances of `of_device_id`
arrays and the number of them which are declared`__initconst`:

    $ git grep 'struct of_device_id.*\[\]' | wc -l
    3089

    $ git grep 'struct of_device_id.*\[\]' | grep __initconst  | wc -l
    117

Not all of these instances are platform drivers, but perhaps deferred
probing with other types of drivers may cause similar issues.

Perhaps it is worthwhile patching stable kernels for the removal of
`__initconst` on these arrays?


And for the larger question -

Freeing of init sections poses an exploitable vulnerability if that memory
is not unmapped, _and_ if there are still accesses taking place due to bugs
of this kind. Linux's build process is supposed to detect references from
non-freed sections to the freed sections, but clearly this instance has
not been detected during build, particularly because we have the `__ref`,
`__refdata`, and `__refconst` attributes which suppress those checks.

Perhaps as a harderning measure, older kernels should be patched with a
config option for not freeing init sections?

--
Dan Aloni
