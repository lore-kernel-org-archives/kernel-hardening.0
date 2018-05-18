MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1520970710-19732-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520970710-19732-1-git-send-email-s.mesoraca16@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 18 May 2018 08:00:59 -0700
Message-ID: <CAGXu5jKJj5rrjX28kqOnavyRXYGu95ZzpV5tZbHvTSJVAz4YBw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: drop a VLA in ocfs2_orphan_del()
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@versity.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 12:51 PM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Andrew, can you take this? It seems the most recent patch to ocfs2
went through your tree...

-Kees

> ---
>  fs/ocfs2/namei.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index c801edd..41ef356 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2332,8 +2332,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>                      struct buffer_head *orphan_dir_bh,
>                      bool dio)
>  {
> -       const int namelen = OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN;
> -       char name[namelen + 1];
> +       char name[OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN + 1];
>         struct ocfs2_dinode *orphan_fe;
>         int status = 0;
>         struct ocfs2_dir_lookup_result lookup = { NULL, };
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
