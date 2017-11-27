Date: Tue, 28 Nov 2017 10:44:52 +1100 (AEDT)
From: James Morris <james.l.morris@oracle.com>
In-Reply-To: <CAGXu5j+YPMZk=TuioD216F5kiqfWTNZcNzpjwOiZRnAfbimhpg@mail.gmail.com>
Message-ID: <alpine.LFD.2.20.1711281041040.13133@localhost>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com> <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com> <20171128.041426.801732093971324601.davem@davemloft.net> <alpine.LFD.2.20.1711280924350.11830@localhost>
 <CAGXu5j+YPMZk=TuioD216F5kiqfWTNZcNzpjwOiZRnAfbimhpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 27 Nov 2017, Kees Cook wrote:

> >         if (WARN_ON_ONCE(!capable(CAP_SYS_MODULE) ||
> >                          !capable(CAP_SYS_ADMIN) ||
> >                          !capable(CAP_NET_ADMIN) ||
> >                          !unprivileged_autoload(module_name)))

(Side note: the capable() calls would ideally come after the whitelist 
check).

> We have some of this already with the module prefixes. Doing this
> per-module would need to be exported to userspace, I think. It'd be
> way too fragile sitting in the kernel.

What about writing a whitelist to /proc (per-task) or /sys/fs (global) ?

The per-task whitelist is inherited from the global one by default, or 
from a parent process if it's been modified in the parent.


-- 
James Morris
<james.l.morris@oracle.com>
