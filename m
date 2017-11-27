MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LFD.2.20.1711280924350.11830@localhost>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
 <20171128.041426.801732093971324601.davem@davemloft.net> <alpine.LFD.2.20.1711280924350.11830@localhost>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Nov 2017 15:04:32 -0800
Message-ID: <CAGXu5j+YPMZk=TuioD216F5kiqfWTNZcNzpjwOiZRnAfbimhpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: James Morris <james.l.morris@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 2:31 PM, James Morris <james.l.morris@oracle.com> wrote:
> On Tue, 28 Nov 2017, David Miller wrote:
>
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Mon, 27 Nov 2017 10:41:30 -0800
>>
>> > What are the real life use-cases for normal users having modules
>> > auto-load?
>>
>> User opens SCTP socket, SCTP protocol module loads.
>>
>> People build test cases via namespaces, and in that namespaces normal
>> users can setup virtual tunnel devices themselves, and those configure
>> operations can bring the tunnel module in.
>
> What about implementing a white list of modules which are able to be
> loaded by unprivileged users?
>
> Then, Linus' solution would look something like:
>
>         va_start(args, fmt);
>         ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
>         va_end(args);
>
>         if (WARN_ON_ONCE(!capable(CAP_SYS_MODULE) ||
>                          !capable(CAP_SYS_ADMIN) ||
>                          !capable(CAP_NET_ADMIN) ||
>                          !unprivileged_autoload(module_name)))
>                 return -EPERM;

We have some of this already with the module prefixes. Doing this
per-module would need to be exported to userspace, I think. It'd be
way too fragile sitting in the kernel.

To control this via modprobe, we'd need to expand modprobe to include
the user that is trying to load the module (so it can reason about who
is doing it), and then teach modprobe about that so the policy could
be exported to userspace.

-Kees

-- 
Kees Cook
Pixel Security
