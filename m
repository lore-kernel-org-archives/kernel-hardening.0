Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 5 Oct 2016 12:34:07 -0700
Message-ID: <CAGXu5j+EtVPabrwPXU0W8yJ5Fg0H0Nc6aPjJqqNOSx+m+TBu2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 5, 2016 at 11:04 AM,  <william.c.roberts@intel.com> wrote:
> From: William Roberts <william.c.roberts@intel.com>
>
> Some out-of-tree modules do not use %pK and just use %p, as it's
> the common C paradigm for printing pointers. Because of this,
> kptr_restrict has no affect on the output and thus, no way to
> contain the kernel address leak.

Solving this is certainly a good idea -- I'm all for finding a solid solution.

> Introduce kptr_restrict level 3 that causes the kernel to
> treat %p as if it was %pK and thus always prints zeros.

I'm worried that this could break kernel internals where %p is being
used and not exposed to userspace. Maybe those situations don't
exist...

Regardless, I would rather do what Grsecurity has done in this area,
and whitelist known-safe values instead. For example, they have %pP
for approved pointers, and %pX for approved
dereference_function_descriptor() output. Everything else is censored
if it is a value in kernel memory and destined for a user-space memory
buffer:

        if ((unsigned long)ptr > TASK_SIZE && *fmt != 'P' && *fmt !=
'X' && *fmt != 'K' && is_usercopy_object(buf)) {
                printk(KERN_ALERT "grsec: kernel infoleak detected!
Please report this log to spender@grsecurity.net.\n");
                dump_stack();
                ptr = NULL;
        }

The "is_usercopy_object()" test is something we can add, which is
testing for a new SLAB flag that is used to mark slab caches as either
used by user-space or not, which is done also through whitelisting.
(For more details on this, see:
http://www.openwall.com/lists/kernel-hardening/2016/06/08/10)

Would you have time/interest to add the slab flags and
is_usercopy_object()? The hardened usercopy part of the slab
whitelisting can be separate, since it likely needs a different
usercopy interface to sanely integrate with upstream.

-Kees

-- 
Kees Cook
Nexus Security
