MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com> <CA+55aFwFEzEU9ci=mFZprjzrhG0P0XgXgqhBSWSv7vFWEAw6rQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 11:02:20 -0800
Message-ID: <CA+55aFwhmgaoHUtCx2=m4SWBtG4dtmY3M8qHLjwe0UaLkBz_eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 0/5] Improve Module autoloading infrastructure
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 10:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> What are the real life use-cases for normal users having modules auto-load?

Well, I could do some testing. One case is apparently both bluetoothd
and ip6tables that have been converted to indeed use CAP_NET_ADMIN.

Annoying.

Still, can't we just say "you need to have capabilities" and leave it at that?

Something (UNTESTED and whitespace damaged) like this:

  diff --git a/kernel/kmod.c b/kernel/kmod.c
  index bc6addd9152b..a3f3218f66c6 100644
  --- a/kernel/kmod.c
  +++ b/kernel/kmod.c
  @@ -139,6 +139,11 @@ int __request_module(bool wait, const char *fmt, ...)
           if (!modprobe_path[0])
                   return 0;

  +        if (WARN_ON_ONCE(!capable(CAP_SYS_MODULE) ||
  +                         !capable(CAP_SYS_ADMIN) ||
  +                         !capable(CAP_NET_ADMIN)))
  +                return -EPERM;
  +
           va_start(args, fmt);
           ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
           va_end(args);

instead of adding complex infrastructure for something people might
not want anyway?

Now, the above will not necessarily work with a legacy /dev/ directory
where al the nodes have been pre-populated, and opening the device
node is supposed to load the module. So _historically_ we did indeed
load modules as normal users. But does that really happen any more?

I'd hate to default to historical behavior if there's no actual reason to do so.

                  Linus
