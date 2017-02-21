Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAKv+Gu8SR7ksDi7_xa76zm6bjgpqZ0h5=BC+kC=GfW_4nuzv=A@mail.gmail.com>
Date: Tue, 21 Feb 2017 15:21:51 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <BAB6E3DA-D1D2-4016-AFE3-03E49F0BF672@gmail.com>
References: <1487498618-16528-1-git-send-email-hoeun.ryu@gmail.com>
 <CAKv+Gu8SR7ksDi7_xa76zm6bjgpqZ0h5=BC+kC=GfW_4nuzv=A@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] introduce __ro_mostly_after_init
 section marker
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On 19 Feb 2017, at 8:14 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> =
wrote:
>=20
> Hi Hoeun,
>=20
> On 19 February 2017 at 10:03, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> After `__ro_after_init` marker is included in kernel, many kernel =
data
>> objects can be read-only-after-init. But there are many other places =
that
>> would be good to read-only-after-init but `__ro_after_init` can not =
be simply
>> applicable to them because they should be writable at some points, =
which are
>> during module_init/exit or dynamic de/registration for a specific =
subsystem.
>=20
> The argument sounds reasonable, but it would really help if you could
> describe some use cases in more detail.

Please see RFC 4/7 [1] and RFC 5/7 [2].

RFC 4 shows that cpu_ap/bp_states are marked as __ro_mostly_after_init.
cpu_ap/bp_states can not be marked as __ro_after_init because some =
modules
can write to those objects using cpuhp_setup/remove_state api during =
module_init/exit.

RFC 5 shows that selinux_hooks and selinux_nf_hooks are marked as =
__ro_mostly_after_init.
those hooks can not be marked as __ro_after_init because =
selinux_disable() function.
Those hooks should be writable during selinux_disable to deregister the =
hooks.

[1] https://lkml.org/lkml/2017/2/19/37
[2] https://lkml.org/lkml/2017/2/19/35

>=20
>> `__ro_mostly_after_init` is basically the same to `__ro_after_init`. =
The
>> section is mapped as read-only after kernel init. The different thing =
is
>> this section is temporarily mapped as read-write during =
module_init/exit and
>> de/registration of a subsystem using set_ro_mostly_after_init_rw/ro =
pair.
>>=20
>> - Tested only on arm64.
>>=20
>> Description:
>>  0001 patch is `__ro_mostly_after_init` itself.
>>  0002 patch is to add set_ro_mostly_after_init_rw/ro pair using
>>    set_memory_rw/ro.
>>  0003 patch is to make the section read-write in module_init/exit.
>>  0004 patch is an example for dynamic init/deinit of a subsystem.
>>  0005 patch is an example for __ro_mostly_after_init section modified =
during
>>    module_init/exit.
>>  0006/0007 patches are fixes for arm64 kernel mapping.
>>=20
>> Hoeun Ryu (7):
>>  arch: add __ro_mostly_after_init section marker
>>  init: add set_ro_mostly_after_init_rw/ro function
>>  module: modify memory attrs for __ro_mostly_after_init during
>>    module_init/exit
>>  selinux: mark __ro_mostly_after_init for =
selinux_hooks/selinux_nf_ops
>>  cpu: mark ro_mostly_after_init for cpuhp_ap/bp_states
>>  arm64: add __map_kernel_segment to accept additional vm flags
>>  arm64: map seperately rodata sections for __ro_mostly_after_init
>>    section
>>=20
>> arch/arm64/mm/mmu.c               | 44 =
++++++++++++++++++++++++++++++++-------
>> include/asm-generic/sections.h    |  1 +
>> include/asm-generic/vmlinux.lds.h | 10 +++++++++
>> include/linux/cache.h             | 11 ++++++++++
>> include/linux/init.h              |  6 ++++++
>> init/main.c                       | 24 +++++++++++++++++++++
>> kernel/cpu.c                      |  4 ++--
>> kernel/module.c                   | 10 +++++++--
>> security/selinux/hooks.c          |  8 +++++--
>> 9 files changed, 105 insertions(+), 13 deletions(-)
>>=20
>> --
>> 2.7.4
>>=20
