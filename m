MIME-Version: 1.0
References: <20181128000754.18056-1-rick.p.edgecombe@intel.com> <20181128000754.18056-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20181128000754.18056-3-rick.p.edgecombe@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 28 Nov 2018 17:40:53 -0800
Message-ID: <CALCETrU+skBS0r6WtkwwMZJvb3s2vWB-JmDeZtVWV8pOkxKojQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86/modules: Make x86 allocs to flush when free
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, jeyu@kernel.org, Network Development <netdev@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Nov 27, 2018, at 4:07 PM, Rick Edgecombe <rick.p.edgecombe@intel.com> =
wrote:
>
> Change the module allocations to flush before freeing the pages.
>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> arch/x86/kernel/module.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index b052e883dd8c..1694daf256b3 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -87,8 +87,8 @@ void *module_alloc(unsigned long size)
>    p =3D __vmalloc_node_range(size, MODULE_ALIGN,
>                    MODULES_VADDR + get_module_load_offset(),
>                    MODULES_END, GFP_KERNEL,
> -                    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
> -                    __builtin_return_address(0));
> +                    PAGE_KERNEL_EXEC, VM_IMMEDIATE_UNMAP,
> +                    NUMA_NO_NODE, __builtin_return_address(0));

Hmm. How awful is the resulting performance for heavy eBPF users?  I=E2=80=
=99m
wondering if the JIT will need some kind of cache to reuse
allocations.

>    if (p && (kasan_module_alloc(p, size) < 0)) {
>        vfree(p);
>        return NULL;
> --
> 2.17.1
>
