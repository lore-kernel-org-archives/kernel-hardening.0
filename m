MIME-Version: 1.0
References: <20181011233117.7883-1-rick.p.edgecombe@intel.com> <20181011233117.7883-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20181011233117.7883-2-rick.p.edgecombe@intel.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 12 Oct 2018 02:35:28 +0200
Message-ID: <CAG48ez2fWg64nGxDXUQS3695KpVNrakAbarXJnYPd6xv5wOD+A@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] modules: Create rlimit for module space
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: rick.p.edgecombe@intel.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, the arch/x86 maintainers <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, kernel list <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org, linux-s390 <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, kristen@linux.intel.com, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 12, 2018 at 1:40 AM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> This introduces a new rlimit, RLIMIT_MODSPACE, which limits the amount of
> module space a user can use. The intention is to be able to limit module =
space
> allocations that may come from un-privlidged users inserting e/BPF filter=
s.

Note that in some configurations (iirc e.g. the default Ubuntu
config), normal users can use the subuid mechanism (the /etc/subuid
config file and the /usr/bin/newuidmap setuid helper) to gain access
to 65536 UIDs, which means that in such a configuration,
RLIMIT_MODSPACE*65537 is the actual limit for one user. (Same thing
applies to RLIMIT_MEMLOCK.)

Also, it is probably possible to waste a few times as much virtual
memory as permitted by the limit by deliberately fragmenting virtual
memory?

> There is unfortunately no cross platform place to perform this accounting
> during allocation in the module space, so instead two helpers are created=
 to be
> inserted into the various arch=E2=80=99s that implement module_alloc. The=
se
> helpers perform the checks and help with tracking. The intention is that =
they
> an be added to the various arch=E2=80=99s as easily as possible.

nit: s/an/can/

[...]
> diff --git a/kernel/module.c b/kernel/module.c
> index 6746c85511fe..2ef9ed95bf60 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2110,9 +2110,139 @@ static void free_module_elf(struct module *mod)
>  }
>  #endif /* CONFIG_LIVEPATCH */
>
> +struct mod_alloc_user {
> +       struct rb_node node;
> +       unsigned long addr;
> +       unsigned long pages;
> +       kuid_t uid;
> +};
> +
> +static struct rb_root alloc_users =3D RB_ROOT;
> +static DEFINE_SPINLOCK(alloc_users_lock);

Why all the rbtree stuff instead of stashing a pointer in struct
vmap_area, or something like that?

[...]
> +int check_inc_mod_rlimit(unsigned long size)
> +{
> +       struct user_struct *user =3D get_current_user();
> +       unsigned long modspace_pages =3D rlimit(RLIMIT_MODSPACE) >> PAGE_=
SHIFT;
> +       unsigned long cur_pages =3D atomic_long_read(&user->module_vm);
> +       unsigned long new_pages =3D get_mod_page_cnt(size);
> +
> +       if (rlimit(RLIMIT_MODSPACE) !=3D RLIM_INFINITY
> +                       && cur_pages + new_pages > modspace_pages) {
> +               free_uid(user);
> +               return 1;
> +       }
> +
> +       atomic_long_add(new_pages, &user->module_vm);
> +
> +       if (atomic_long_read(&user->module_vm) > modspace_pages) {
> +               atomic_long_sub(new_pages, &user->module_vm);
> +               free_uid(user);
> +               return 1;
> +       }
> +
> +       free_uid(user);

If you drop the reference on the user_struct, an attacker with two
UIDs can charge module allocations to UID A, keep the associated
sockets alive as UID B, and then log out and back in again as UID A.
At that point, nobody is charged for the module space anymore. If you
look at the eBPF implementation, you'll see that
bpf_prog_charge_memlock() actually stores a refcounted pointer to the
user_struct.

> +       return 0;
> +}
