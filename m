MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAG48ez3z=5pgpG2B=AEEB1q6NPuZ9=LXKcOd8PEer1GUSdgjKw@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-5-git-send-email-me@tobin.cc> <CAGXu5jJQOduZ5evB=1w5NymUFbDNoeB4Y4u2a7zJ8k8vsAojRQ@mail.gmail.com>
 <CA+55aFxBrFsN0wm1_SyafNZ6GHxCLBvwmRaAzfKD9xnS7K3XGg@mail.gmail.com>
 <CA+55aFw-MCtMHb6mAoTXU8dJCRNfwzrV7tS=aQZXryfeB9TExg@mail.gmail.com> <CAG48ez3z=5pgpG2B=AEEB1q6NPuZ9=LXKcOd8PEer1GUSdgjKw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 12:23:02 -0700
Message-ID: <CA+55aFwqyAzMR6PRYxu90Q2sB_cJ5JcP3ELH-BUGi-m0ti=X1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default
 kptr_restrict to the maximum value
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 12:13 PM, Jann Horn <jannh@google.com> wrote:
>
> Actually, /proc/kallsyms uses %pK, which hacks around this issue
> by checking for `euid != uid` in addition to the capability check - so this
> isn't exploitable through a typical setuid program.

Fair enough, you'd have to be a pretty broken suid program to have set
uid to euid before reading some untrusted file descriptor.

I could still imagine happening (hey, the X server used to sendmsg
file descriptors back and forth), but hopefully it's not really
realistic.

                  Linus
