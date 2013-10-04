Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524E118F.9080503@gmail.com>
Date: Fri, 04 Oct 2013 10:53:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>	<871u5gqtw3.fsf@xmission.com>	<20130826172054.GE27005@ZenIV.linux.org.uk>	<20130827172406.GA2664@dztty>	<20130828201141.GA21455@dztty>	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com> <CAGXu5jLSXO_MzLtEn_9gdiWmEru+=o1ZnZ8z-m=KZy37Ry4NDQ@mail.gmail.com>
In-Reply-To: <CAGXu5jLSXO_MzLtEn_9gdiWmEru+=o1ZnZ8z-m=KZy37Ry4NDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
To: Kees Cook <keescook@chromium.org>, Djalal Harouni <tixxdz@opendz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, George Spelvin <linux@horizon.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/10/13 10:41, Kees Cook wrote:
> On Wed, Aug 28, 2013 at 1:49 PM, Kees Cook <keescook@chromium.org> wrote:

<snip>

> 
> BTW, this just came to my attention:
> http://marc.info/?l=linux-kernel&m=138049414321387&w=2
> 
> Same problem, just for /proc/kallsyms. This would benefit from the
> open vs read cred check as well, I think.

I was actually just about to put together a repost of this. Sorry I
missed you off the original Cc list, get_maintainer didn't list you.

I wanted to at least change the comment mentioning "badly written"
setuid binaries. That isn't really true, as George Spelvin pointed out,
even a setuid binary which opens the file with dropped priviledges, but
reads it after re-elevating privileges will be susceptible to this.

Setuid apps could be more precautious by doing the open + read into
memory of user files with the privileges dropped, so that once
privileges are re-elevated only the in-memory copy is used.

I still think in-kernel fixing is a good idea too though, since it
hardens against user-space setuid apps that don't do this. This was just
the simplest approach to fixing the problem that I could think of. I'm
open to suggestions for a better solution.

~Ryan
