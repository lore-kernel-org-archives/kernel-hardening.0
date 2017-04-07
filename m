Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <1490811363-93944-2-git-send-email-keescook@chromium.org>
Date: Fri, 7 Apr 2017 17:09:18 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDCFFA43-5B6D-42CB-A65C-5FA485B64C7A@gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [RFC v2][PATCH 01/11] Introduce rare_write() infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>


> On 30 Mar 2017, at 3:15 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
> Several types of data storage exist in the kernel: read-write data =
(.data,
> .bss), read-only data (.rodata), and RO-after-init. This introduces =
the
> infrastructure for another type: write-rarely, which is intended for =
data
> that is either only rarely modified or especially security-sensitive. =
The
> goal is to further reduce the internal attack surface of the kernel by
> making this storage read-only when "at rest". This makes it much =
harder
> to be subverted by attackers who have a kernel-write flaw, since they
> cannot directly change these memory contents.
>=20
> This work is heavily based on PaX and grsecurity's =
pax_{open,close}_kernel
> API, its __read_only annotations, its constify plugin, and the work =
done
> to identify sensitive structures that should be moved from .data into
> .rodata. This builds the initial infrastructure to support these kinds
> of changes, though the API and naming has been adjusted in places for
> clarity and maintainability.
>=20
> Variables declared with the __wr_rare annotation will be moved to the
> .rodata section if an architecture supports =
CONFIG_HAVE_ARCH_WRITE_RARE.
> To change these variables, either a single rare_write() macro can be =
used,
> or multiple uses of __rare_write(), wrapped in a matching pair of
> rare_write_begin() and rare_write_end() macros can be used. These =
macros
> are expanded into the arch-specific functions that perform the actions
> needed to write to otherwise read-only memory.
>=20
> As detailed in the Kconfig help, the arch-specific helpers have =
several
> requirements to make them sensible/safe for use by the kernel: they =
must
> not allow non-current CPUs to write the memory area, they must run
> non-preemptible to avoid accidentally leaving memory writable, and =
must
> be inline to avoid making them desirable ROP targets for attackers.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> arch/Kconfig             | 25 +++++++++++++++++++++++++
> include/linux/compiler.h | 32 ++++++++++++++++++++++++++++++++
> include/linux/preempt.h  |  6 ++++--
> 3 files changed, 61 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/Kconfig b/arch/Kconfig
> index cd211a14a88f..5ebf62500b99 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -847,4 +847,29 @@ config STRICT_MODULE_RWX
> config ARCH_WANT_RELAX_ORDER
> 	bool
>=20
> +config HAVE_ARCH_RARE_WRITE
> +	def_bool n
> +	help
> +	  An arch should select this option if it has defined the =
functions
> +	  __arch_rare_write_begin() and __arch_rare_write_end() to
> +	  respectively enable and disable writing to read-only memory. =
The
> +	  routines must meet the following requirements:
> +	  - read-only memory writing must only be available on the =
current
> +	    CPU (to make sure other CPUs can't race to make changes =
too).
> +	  - the routines must be declared inline (to discourage ROP =
use).
> +	  - the routines must not be preemptible (likely they will call
> +	    preempt_disable() and preempt_enable_no_resched() =
respectively).
> +	  - the routines must validate expected state (e.g. when =
enabling
> +	    writes, BUG() if writes are already be enabled).
> +
> +config HAVE_ARCH_RARE_WRITE_MEMCPY
> +	def_bool n
> +	depends on HAVE_ARCH_RARE_WRITE
> +	help
> +	  An arch should select this option if a special accessor is =
needed
> +	  to write to otherwise read-only memory, defined by the =
function
> +	  __arch_rare_write_memcpy(). Without this, the write-rarely
> +	  infrastructure will just attempt to write directly to the =
memory
> +	  using a const-ignoring assignment.
> +
> source "kernel/gcov/Kconfig"
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index f8110051188f..274bd03cfe9e 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -336,6 +336,38 @@ static __always_inline void =
__write_once_size(volatile void *p, void *res, int s
> 	__u.__val;					\
> })
>=20
> +/*
> + * Build "write rarely" infrastructure for flipping memory r/w
> + * on a per-CPU basis.
> + */
> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
> +# define __wr_rare
> +# define __wr_rare_type
> +# define __rare_write(__var, __val)	(__var =3D (__val))
> +# define rare_write_begin()		do { } while (0)
> +# define rare_write_end()		do { } while (0)
> +#else
> +# define __wr_rare			__ro_after_init
> +# define __wr_rare_type			const
> +# ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY
> +#  define __rare_write_n(dst, src, len)	({			=
\
> +		BUILD_BUG(!builtin_const(len));			\
> +		__arch_rare_write_memcpy((dst), (src), (len));	\
> +	})
> +#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), =
sizeof(var))
> +# else
> +#  define __rare_write(var, val)  ((*(typeof((typeof(var))0) =
*)&(var)) =3D (val))
> +# endif
> +# define rare_write_begin()	__arch_rare_write_begin()
> +# define rare_write_end()	__arch_rare_write_end()
> +#endif
> +#define rare_write(__var, __val) ({			\
> +	rare_write_begin();				\
> +	__rare_write(__var, __val);			\
> +	rare_write_end();				\
> +	__var;						\
> +})
> +

How about we have a separate header file splitting section annotations =
and the actual APIs.

include/linux/compiler.h:
    __wr_rare
    __wr_rare_type

include/linux/rare_write.h:
    __rare_write_n()
    __rare_write()
    rare_write_begin()
    rare_write_end()

OR moving all of them to include/linux/rare_write.h.

I=E2=80=99m writing the arm64 port for rare_write feature and I=E2=80=99ve=
 stucked in some header problems for the next version of the patch.
I need some other mmu related APIs (mostly defined in =
`arch/arm64/include/asm/mmu_context.h`) to implement those helpers.
but I cannot include the header in `include/linux/compiler.h` prior to =
definition of rare_write macros (huge compilation errors).
You know that `linux/compiler.h` header is mostly base of other headers =
not a user.

I have to define `__arch_rare_write_[begin/end/memcpy]()` functions as =
`static inline` in a header file somewhere in `arch/arm64/include/asm/`
to avoid making them ROP targets and the helpers need other mmu related =
APIs.
And the helpers and the mmu related APIs cannot be defined prior to =
definition of rare_write macros in `linux/compile.h`.

And I think I'll need `include/linux/module.h` for module related APIs =
like `is_module_address()` to support module address conversion
in `__arch_rare_write_memcpy()` and it=E2=80=99ll make the situation =
worse.

* make `include/linux/rare_write.h`
* the header defines rare_write APIs
* the header includes `include/asm/rare_write.h` for arch-specific =
helpers
* users using rare_write feature should include `linux/rare_write.h`

OR suggest other solutions please.

> #endif /* __KERNEL__ */
>=20
> #endif /* __ASSEMBLY__ */
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index cae461224948..4fc97aaa22ea 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -258,10 +258,12 @@ do { \
> /*
>  * Modules have no business playing preemption tricks.
>  */
> -#undef sched_preempt_enable_no_resched
> -#undef preempt_enable_no_resched
> #undef preempt_enable_no_resched_notrace
> #undef preempt_check_resched
> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
> +#undef sched_preempt_enable_no_resched
> +#undef preempt_enable_no_resched
> +#endif
> #endif
>=20
> #define preempt_set_need_resched() \
> --=20
> 2.7.4
>=20
