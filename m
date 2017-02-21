Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170220102226.GB9003@leverpostej>
Date: Tue, 21 Feb 2017 15:33:24 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <958BFDD0-E4AC-479D-B3BD-027CF0522900@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-2-git-send-email-hoeun.ryu@gmail.com>
 <20170220102226.GB9003@leverpostej>
Subject: Re: [kernel-hardening] [RFC 2/7] init: add
 set_ro_mostly_after_init_rw/ro function
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@redhat.com>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Fabian Frederick <fabf@skynet.be>, Helge Deller <deller@gmx.de>, Laura Abbott <labbott@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Petr Mladek <pmladek@suse.com>, Yang Shi <yang.shi@linaro.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Tejun Heo <tj@kernel.org>, Prarit Bhargava <prarit@redhat.com>, Lokesh Vutla <lokeshvutla@ti.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On 20 Feb 2017, at 7:22 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
> On Sun, Feb 19, 2017 at 07:04:05PM +0900, Hoeun Ryu wrote:
>> Add set_ro_mostly_after_init_rw/ro pair to modify memory attributes =
for
>> memory marked as `ro_mostly_after_init`.
>>=20
>> I am doubtful that this is the right place where these functions =
reside and
>> these functions are suitable for all architectures for memory =
attributes
>> modification. Please comment.
>=20
> These won't work for arm64, since set_memory_* only work on
> page-granular mappings in the vmalloc area.
>=20
> The "real" kernel mappings can use larger block mappings, and would =
need
> to be split (which cannot be done at runtime) before permissions could
> be changed at page granularity.

So I sent RFC 6/7 [1] and 7/7 [2] that splits the block mapping to the =
page granular.
I think you and Ard Biesheuvel don=E2=80=99t like it anyway.

[1] : https://lkml.org/lkml/2017/2/19/38
[2] : https://lkml.org/lkml/2017/2/19/39

>=20
> Thanks,
> Mark.
>=20
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>> include/linux/init.h |  6 ++++++
>> init/main.c          | 24 ++++++++++++++++++++++++
>> 2 files changed, 30 insertions(+)
>>=20
>> diff --git a/include/linux/init.h b/include/linux/init.h
>> index 79af096..d68e4f7 100644
>> --- a/include/linux/init.h
>> +++ b/include/linux/init.h
>> @@ -131,6 +131,12 @@ extern bool rodata_enabled;
>> #endif
>> #ifdef CONFIG_STRICT_KERNEL_RWX
>> void mark_rodata_ro(void);
>> +
>> +void set_ro_mostly_after_init_rw(void);
>> +void set_ro_mostly_after_init_ro(void);
>> +#else
>> +static inline void set_ro_mostly_after_init_rw(void) { }
>> +static inline void set_ro_mostly_after_init_ro(void) { }
>> #endif
>>=20
>> extern void (*late_time_init)(void);
>> diff --git a/init/main.c b/init/main.c
>> index 4719abf..a5d4873 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -941,6 +941,30 @@ static void mark_readonly(void)
>> 	} else
>> 		pr_info("Kernel memory protection disabled.\n");
>> }
>> +
>> +void set_ro_mostly_after_init_rw(void)
>> +{
>> +	unsigned long start =3D =
PFN_ALIGN(__start_data_ro_mostly_after_init);
>> +	unsigned long end =3D =
PFN_ALIGN(&__end_data_ro_mostly_after_init);
>> +	unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
>> +
>> +	if (!rodata_enabled)
>> +		return;
>> +
>> +	set_memory_rw(start, nr_pages);
>> +}
>> +
>> +void set_ro_mostly_after_init_ro(void)
>> +{
>> +	unsigned long start =3D =
PFN_ALIGN(__start_data_ro_mostly_after_init);
>> +	unsigned long end =3D =
PFN_ALIGN(&__end_data_ro_mostly_after_init);
>> +	unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
>> +
>> +	if (!rodata_enabled)
>> +		return;
>> +
>> +	set_memory_ro(start, nr_pages);
>> +}
>> #else
>> static inline void mark_readonly(void)
>> {
>> --=20
>> 2.7.4
>>=20
