Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAKv+Gu8J03Hr1xZ3Q7+z9RV1o4bZOZ83hTTeX=QdQN0rXrMYSQ@mail.gmail.com>
Date: Tue, 21 Feb 2017 15:29:01 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <FEDBF9D8-8397-43FF-8640-3795CC7A1B04@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <CAKv+Gu8J03Hr1xZ3Q7+z9RV1o4bZOZ83hTTeX=QdQN0rXrMYSQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC 1/7] arch: add __ro_mostly_after_init
 section marker
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On 19 Feb 2017, at 8:24 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> =
wrote:
>=20
> On 19 February 2017 at 10:04, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
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
>> `__ro_mostly_after_init` is basically the same to `__ro_after_init`. =
The
>> section is mapped as read-only after kernel init. The different thing =
is
>> this section is temporarily mapped as read-write during =
module_init/exit and
>> de/registration of a subsystem using set_ro_mostly_after_init_rw/ro =
pair.
>> Use `__ro_mostly_after_init` as a way to mark such memory instead =
when
>> `__ro_after_init` is not applicable because the memory should be =
writable
>> at the described points of time. They are read-only right after =
kernel init
>> and writable temporarily only during module_init/exit and dynamic
>> de/registration for a subsystem.
>>=20
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>> include/asm-generic/sections.h    |  1 +
>> include/asm-generic/vmlinux.lds.h | 10 ++++++++++
>> include/linux/cache.h             | 11 +++++++++++
>> 3 files changed, 22 insertions(+)
>>=20
>> diff --git a/include/asm-generic/sections.h =
b/include/asm-generic/sections.h
>> index 4df64a1..16a6f21 100644
>> --- a/include/asm-generic/sections.h
>> +++ b/include/asm-generic/sections.h
>> @@ -34,6 +34,7 @@ extern char __bss_start[], __bss_stop[];
>> extern char __init_begin[], __init_end[];
>> extern char _sinittext[], _einittext[];
>> extern char __start_data_ro_after_init[], __end_data_ro_after_init[];
>> +extern char __start_data_ro_mostly_after_init[], =
__end_data_ro_mostly_after_init[];
>> extern char _end[];
>> extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
>> extern char __kprobes_text_start[], __kprobes_text_end[];
>> diff --git a/include/asm-generic/vmlinux.lds.h =
b/include/asm-generic/vmlinux.lds.h
>> index 4e09b28..cc5f44e 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -265,6 +265,15 @@
>>        __end_data_ro_after_init =3D .;
>> #endif
>>=20
>> +#ifndef RO_MOSTLY_AFTER_INIT_DATA
>> +#define RO_MOSTLY_AFTER_INIT_DATA(align)                             =
  \
>> +       . =3D ALIGN(align);                                           =
    \
>> +       VMLINUX_SYMBOL(__start_data_ro_mostly_after_init) =3D .;      =
    \
>> +       *(.data..ro_mostly_after_init)                                =
  \
>> +       . =3D ALIGN(align);                                           =
    \
>> +       VMLINUX_SYMBOL(__end_data_ro_mostly_after_init) =3D .;
>> +#endif
>> +
>> /*
>>  * Read only Data
>>  */
>> @@ -275,6 +284,7 @@
>>                *(.rodata) *(.rodata.*)                                =
 \
>>                RO_AFTER_INIT_DATA      /* Read only after init */     =
 \
>>                KEEP(*(__vermagic))     /* Kernel version magic */     =
 \
>> +               RO_MOSTLY_AFTER_INIT_DATA(align)                      =
  \
>=20
> You can't really drop this in the middle of a section like this. On
> arm64, we try very hard to use a minimal segment alignment of 64 KB
> (of 2 MB if DEBUG_ALIGN_RODATA=3Dy), to ensure that the TLB footprint =
of
> the kernel image is minimized.
>=20
> So this should be a separate section in the arm64 linker script.
>=20

Could we achieve that using ALIGN(SECTION_SIZE) not ALIGN(PAGE_SIZE) for =
RO_DATA ?

>>                . =3D ALIGN(8);                                        =
   \
>>                VMLINUX_SYMBOL(__start___tracepoints_ptrs) =3D .;      =
   \
>>                KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer =
array */ \
>> diff --git a/include/linux/cache.h b/include/linux/cache.h
>> index 1be04f8..fd1cb9b 100644
>> --- a/include/linux/cache.h
>> +++ b/include/linux/cache.h
>> @@ -30,6 +30,17 @@
>> #define __ro_after_init =
__attribute__((__section__(".data..ro_after_init")))
>> #endif
>>=20
>> +/*
>> + * __ro_mostly_after_init is almost like __ro_after_init.
>> + * but __ro_mostly_after_init section is temporarily writable only =
during
>> + * module_init/exit or dynamic de/registeration of a subsystem using
>> + * set_ro_mostly_after_init_rw/ro pair.
>> + */
>> +#ifndef __ro_mostly_after_init
>> +#define __ro_mostly_after_init \
>> +       __attribute__((__section__(".data..ro_mostly_after_init")))
>> +#endif
>> +
>> #ifndef ____cacheline_aligned
>> #define ____cacheline_aligned =
__attribute__((__aligned__(SMP_CACHE_BYTES)))
>> #endif
>> --
>> 2.7.4
