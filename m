MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1497544976-7856-6-git-send-email-s.mesoraca16@gmail.com>
References: <1497544976-7856-1-git-send-email-s.mesoraca16@gmail.com> <1497544976-7856-6-git-send-email-s.mesoraca16@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Jun 2017 16:04:17 -0700
Message-ID: <CAGXu5jJuQx2qOt_aDqDQDcqGOZ5kmr5rQ9Zjv=MRRCJ65ERfGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC v2 5/9] S.A.R.A. WX Protection
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux-MM <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, Jann Horn <jannh@google.com>, Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 15, 2017 at 9:42 AM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> +static int sara_check_vmflags(vm_flags_t vm_flags)
> +{
> +       u16 sara_wxp_flags = get_current_sara_wxp_flags();
> +
> +       if (sara_enabled && wxprot_enabled) {
> +               if (sara_wxp_flags & SARA_WXP_WXORX &&
> +                   vm_flags & VM_WRITE &&
> +                   vm_flags & VM_EXEC) {
> +                       if ((sara_wxp_flags & SARA_WXP_VERBOSE))
> +                               pr_wxp("W^X");
> +                       if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))
> +                               return -EPERM;
> +               }
> +               if (sara_wxp_flags & SARA_WXP_MMAP &&
> +                   (vm_flags & VM_EXEC ||
> +                    (!(vm_flags & VM_MAYWRITE) && (vm_flags & VM_MAYEXEC))) &&
> +                   get_current_sara_mmap_blocked()) {
> +                       if ((sara_wxp_flags & SARA_WXP_VERBOSE))
> +                               pr_wxp("executable mmap");
> +                       if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))
> +                               return -EPERM;
> +               }
> +       }

Given the subtle differences between these various if blocks (here and
in the other hook), I think it would be nice to have some beefy
comments here to describe specifically what's being checked (and why).
It'll help others review this code, and help validate code against
intent.

I would also try to minimize the written code by creating a macro for
a repeated pattern here:

> +                               if ((sara_wxp_flags & SARA_WXP_VERBOSE))
> +                                       pr_wxp("mprotect on file mmap");
> +                               if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))
> +                                       return -EACCES;

These four lines are repeated several times with only the const char *
and return value changing. Perhaps something like:

#define sara_return(err, msg) do { \
                               if ((sara_wxp_flags & SARA_WXP_VERBOSE)) \
                                       pr_wxp(err); \
                               if (!(sara_wxp_flags & SARA_WXP_COMPLAIN)) \
                                       return -err; \
} while (0)

Then each if block turns into something quite easier to parse:

               if (sara_wxp_flags & SARA_WXP_WXORX &&
                   vm_flags & VM_WRITE &&
                   vm_flags & VM_EXEC)
                       sara_return(EPERM, "W^X");


-Kees

-- 
Kees Cook
Pixel Security
