MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 10:41:30 -0800
Message-ID: <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 9:18 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>
> The sysctl flag is available at "/proc/sys/kernel/modules_autoload_mode"
>
> When modules_autoload_mode is set to (0), the default, there are no
> restrictions.

So quick question: do we actually need this?

Yes, it may be the current default, but is it anything that people
actually depend on?

I'd have expected that most module loading comes from system actions
anyway, not normal users.

So I'd like to explore first whether it even makes sense to make a new option.

New options are bad because:

 - opt-in security isn't security at all

 - having to configure things is complex

so we should generally strive to _not_ need new random config options.

What are the real life use-cases for normal users having modules auto-load?

               Linus
