MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170510173637.25116-1-danielmicay@gmail.com>
References: <20170510173637.25116-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 10 May 2017 11:16:28 -0700
Message-ID: <CAGXu5j+Beak21r4YVV-dQNOmJdmwEdrvaf-xi_fKqk-Ckb-gDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] mark most percpu globals as __ro_after_init
To: Daniel Micay <danielmicay@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 10, 2017 at 10:36 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> Moving pcpu_base_addr to this section comes from PaX where it's part of
> KERNEXEC. This extends it to the rest of the globals only written by the
> init code.
>
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>

Excellent, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  mm/percpu.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/mm/percpu.c b/mm/percpu.c
> index e0aa8ae7bde7..c03753054099 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -121,35 +121,35 @@ struct pcpu_chunk {
>         unsigned long           populated[];    /* populated bitmap */
>  };
>
> -static int pcpu_unit_pages __read_mostly;
> -static int pcpu_unit_size __read_mostly;
> -static int pcpu_nr_units __read_mostly;
> -static int pcpu_atom_size __read_mostly;
> -static int pcpu_nr_slots __read_mostly;
> -static size_t pcpu_chunk_struct_size __read_mostly;
> +static int pcpu_unit_pages __ro_after_init;
> +static int pcpu_unit_size __ro_after_init;
> +static int pcpu_nr_units __ro_after_init;
> +static int pcpu_atom_size __ro_after_init;
> +static int pcpu_nr_slots __ro_after_init;
> +static size_t pcpu_chunk_struct_size __ro_after_init;
>
>  /* cpus with the lowest and highest unit addresses */
> -static unsigned int pcpu_low_unit_cpu __read_mostly;
> -static unsigned int pcpu_high_unit_cpu __read_mostly;
> +static unsigned int pcpu_low_unit_cpu __ro_after_init;
> +static unsigned int pcpu_high_unit_cpu __ro_after_init;
>
>  /* the address of the first chunk which starts with the kernel static area */
> -void *pcpu_base_addr __read_mostly;
> +void *pcpu_base_addr __ro_after_init;
>  EXPORT_SYMBOL_GPL(pcpu_base_addr);
>
> -static const int *pcpu_unit_map __read_mostly;         /* cpu -> unit */
> -const unsigned long *pcpu_unit_offsets __read_mostly;  /* cpu -> unit offset */
> +static const int *pcpu_unit_map __ro_after_init;               /* cpu -> unit */
> +const unsigned long *pcpu_unit_offsets __ro_after_init;        /* cpu -> unit offset */
>
>  /* group information, used for vm allocation */
> -static int pcpu_nr_groups __read_mostly;
> -static const unsigned long *pcpu_group_offsets __read_mostly;
> -static const size_t *pcpu_group_sizes __read_mostly;
> +static int pcpu_nr_groups __ro_after_init;
> +static const unsigned long *pcpu_group_offsets __ro_after_init;
> +static const size_t *pcpu_group_sizes __ro_after_init;
>
>  /*
>   * The first chunk which always exists.  Note that unlike other
>   * chunks, this one can be allocated and mapped in several different
>   * ways and thus often doesn't live in the vmalloc area.
>   */
> -static struct pcpu_chunk *pcpu_first_chunk;
> +static struct pcpu_chunk *pcpu_first_chunk __ro_after_init;
>
>  /*
>   * Optional reserved chunk.  This chunk reserves part of the first
> @@ -158,13 +158,13 @@ static struct pcpu_chunk *pcpu_first_chunk;
>   * area doesn't exist, the following variables contain NULL and 0
>   * respectively.
>   */
> -static struct pcpu_chunk *pcpu_reserved_chunk;
> -static int pcpu_reserved_chunk_limit;
> +static struct pcpu_chunk *pcpu_reserved_chunk __ro_after_init;
> +static int pcpu_reserved_chunk_limit __ro_after_init;
>
>  static DEFINE_SPINLOCK(pcpu_lock);     /* all internal data structures */
>  static DEFINE_MUTEX(pcpu_alloc_mutex); /* chunk create/destroy, [de]pop, map ext */
>
> -static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
> +static struct list_head *pcpu_slot __ro_after_init; /* chunk list slots */
>
>  /* chunks which need their map areas extended, protected by pcpu_lock */
>  static LIST_HEAD(pcpu_map_extend_chunks);
> --
> 2.12.2
>



-- 
Kees Cook
Pixel Security
