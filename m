MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170602152010.2064-2-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com> <20170602152010.2064-2-riel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Jun 2017 12:27:44 -0700
Message-ID: <CAGXu5jKcuV7jfPotd1y6GNWk=jyvvb2xqYGS8hMx8qD9de=uzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 1/6] binfmt_elf: document load_bias a
 little bit
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Daniel Micay <danielmicay@gmail.com>, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 8:20 AM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> After me and another unnamed developer got confused by the subtraction
> of vaddr in this branch of the code, followed by adding vaddr back in
> a little bit later, for the third time, maybe it is time to document
> this quirky bit of code.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

Any and all improvements to this code and its documentation are welcome. :)

-Kees

> ---
>  fs/binfmt_elf.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 5075fd5c62c8..8c3f4dbc7603 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -930,10 +930,16 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                 if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
>                         elf_flags |= MAP_FIXED;
>                 } else if (loc->elf_ex.e_type == ET_DYN) {
> -                       /* Try and get dynamic programs out of the way of the
> +                       /*
> +                        * Try and get dynamic programs out of the way of the
>                          * default mmap base, as well as whatever program they
>                          * might try to exec.  This is because the brk will
> -                        * follow the loader, and is not movable.  */
> +                        * follow the loader, and is not movable.
> +                        *
> +                        * The load_bias is the difference between the address
> +                        * in the elf header and the address where the binary
> +                        * is mmapped.
> +                        */
>                         load_bias = ELF_ET_DYN_BASE - vaddr;
>                         if (current->flags & PF_RANDOMIZE)
>                                 load_bias += arch_mmap_rnd();
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
