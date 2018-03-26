Date: Mon, 26 Mar 2018 13:52:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] task_struct: Allow randomized layout
Message-ID: <20180326115246.GA4147@hirez.programming.kicks-ass.net>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
 <1497905801-69164-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497905801-69164-2-git-send-email-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 01:56:38PM -0700, Kees Cook wrote:
> This marks most of the layout of task_struct as randomizable, but leaves
> thread_info and scheduler state untouched at the start, and thread_struct
> untouched at the end.
> 
> Other parts of the kernel use unnamed structures, but the 0-day builder
> using gcc-4.4 blows up on static initializers. Officially, it's documented
> as only working on gcc 4.6 and later, which further confuses me:
> 	https://gcc.gnu.org/wiki/C11Status
> The structure layout randomization already requires gcc 4.7, but instead
> of depending on the plugin being enabled, just check the gcc versions
> for wider build testing. At Linus's suggestion, the marking is hidden
> in a macro to reduce how ugly it looks. Additionally, indenting is left
> unchanged since it would make things harder to read.
> 
> Randomization of task_struct is modified from Brad Spengler/PaX Team's
> code in the last public patch of grsecurity/PaX based on my understanding
> of the code. Changes or omissions from the original code are mine and
> don't reflect the original grsecurity/PaX code.
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks for the Cc :/

> +#define randomized_struct_fields_start	struct {
> +#define randomized_struct_fields_end	} __randomize_layout;

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f833254fce00..e2ad3531e7fe 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -490,6 +490,13 @@ struct task_struct {
>  #endif
>  	/* -1 unrunnable, 0 runnable, >0 stopped: */
>  	volatile long			state;
> +
> +	/*
> +	 * This begins the randomizable portion of task_struct. Only
> +	 * scheduling-critical items should be added above here.
> +	 */
> +	randomized_struct_fields_start
> +
>  	void				*stack;
>  	atomic_t			usage;
>  	/* Per task flags (PF_*), defined further below: */


That now looks like:

struct task_struct {
        struct thread_info         thread_info;          /*     0    16 */
        volatile long int          state;                /*    16     8 */

        /* XXX 40 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        struct {
                void *             stack;                /*    64     8 */
                atomic_t           usage;                /*    72     4 */
                unsigned int       flags;                /*    76     4 */
                unsigned int       ptrace;               /*    80     4 */
                struct llist_node  wake_entry;           /*    88     8 */


Can we please undo this crap?
