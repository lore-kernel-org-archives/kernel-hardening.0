Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170220100213.GA9003@leverpostej>
Date: Tue, 21 Feb 2017 15:10:45 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <FAEFA506-D7DB-4D92-A773-3A6EA966FE4A@gmail.com>
References: <1487498618-16528-1-git-send-email-hoeun.ryu@gmail.com>
 <20170220100213.GA9003@leverpostej>
Subject: Re: [kernel-hardening] [PATCH 0/7] introduce __ro_mostly_after_init
 section marker
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


> On 20 Feb 2017, at 7:02 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
> On Sun, Feb 19, 2017 at 07:03:38PM +0900, Hoeun Ryu wrote:
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
> Could you elaborate on this?
>=20
> For modules, I assume that the __ro_after_init data structures are =
part
> of the module, and not part of the "real" kernel image. Is that the =
case?
>=20

__ro_mostly_after_init is for kernel builtin core subsystems, not for =
modules themselves.
The section can be writable only during kernel init and =
module_init/exit.
Some hooks (or array of hooks) of a core subsystem can be marked as =
__ro_mostly_after_init
similar to that way of __ro_after_init. After that some modules that may =
write to those hooks of
the subsystem to register/deregister something to the subsystem can =
safely access those section.
Please see RFC 3/7 that makes this section writable.

In addition, some subsystems may use this marker for their (array of) =
hooks and make them writable
only at some point of time via set_ro_mostly_after_init_rw/ro pair.
please read RFC 4/7 for selinux.

> Which specific subsystems whish to modify data structures that are
> __ro_after_init?

I=E2=80=99m not intending to make writable __ro_after_init section but =
introducing new section marker
that works mostly like __ro_after_init but can be written to at some =
points.
please see RFC 5/7 for cpuhotplug.

>=20
> This sounds like the proposed mostly-ro/rarely-rw stuff would be a
> better fit for that case.
>=20
> Thanks,
> Mark.
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
>> --=20
>> 2.7.4
>>=20
