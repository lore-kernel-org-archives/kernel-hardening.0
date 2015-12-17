Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1450364270-12687-3-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<1450364270-12687-3-git-send-email-dave@progbits.org>
Date: Thu, 17 Dec 2015 12:56:54 -0800
Message-ID: <CAGXu5jLYkvaFJ=m5j=r5UVajhKY5sbavJ9kJLnt-e=ObwzWshA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 02/12] percpu_ref: decrease
 per-CPU refcount bias
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrote:
> This change is necessary to prevent overflows from occuring in
> percpu_switch_to_atomic_rcu during init on x86.

I'm curious to find out why this overflows under "normal" operation.
Is there any downside to this change?

-Kees

>
> Signed-off-by: David Windsor <dave@progbits.org>
> ---
>  lib/percpu-refcount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 6111bcb..02e816b 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -31,7 +31,7 @@
>   * atomic_long_t can't hit 0 before we've added up all the percpu refs.
>   */
>
> -#define PERCPU_COUNT_BIAS      (1LU << (BITS_PER_LONG - 1))
> +#define PERCPU_COUNT_BIAS      (1LU << (BITS_PER_LONG - 2))
>
>  static DECLARE_WAIT_QUEUE_HEAD(percpu_ref_switch_waitq);
>
> --
> 2.5.0
>
>



-- 
Kees Cook
Chrome OS & Brillo Security
