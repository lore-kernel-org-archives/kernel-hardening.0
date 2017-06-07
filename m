MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170606215534.GA13126@openwall.com>
References: <20170606215534.GA13126@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 6 Jun 2017 21:10:43 -0700
Message-ID: <CAGXu5j+tMVT2uQMP74KsYfvN-uFtQmjin-mON9gAs-qAMUq52Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: Solar Designer <solar@openwall.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 2:55 PM, Solar Designer <solar@openwall.com> wrote:
> The hardlink restrictions differ between -ow vs. grsecurity and upstream.
> In -ow, I had the check in vfs_link().  In grsecurity (oldest I checked
> now is grsecurity-2.1.11-2.4.35-200708071800), it's in sys_link() and
> later in sys_linkat(), which is also called by sys_link().  Upstream
> also has it right in the linkat() syscall function.  Maybe there were
> good reasons not to do it in vfs_link(), but I am unaware of those.
> We need to know what currently happens and what we'd like to happen for
> other callers to vfs_link(), such as kernel nfsd and CRIU - do we want
> the restrictions to apply there?  Maybe for some of those other callers,
> but not for all?  Do the same checks work correctly when called from
> those other contexts or do we need revised checks there?

Hm, yeah, I don't remember sys_linkat() vs vfs_link() coming up during
review, but it's been a while. The nfsd thing is interesting... would
it be right to refuse a client's linkat based on the server's link
restriction sysctl? Hmm.

> As to the FIFO restrictions, those don't appear to have been merged
> upstream yet.

Do the FIFO restrictions exist in -ow too? I wonder what enabling that
protection might break... (better asked as "omg, what puts FIFOs in +t
directories?")

-Kees

-- 
Kees Cook
Pixel Security
