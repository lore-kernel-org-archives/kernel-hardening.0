MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFxBrFsN0wm1_SyafNZ6GHxCLBvwmRaAzfKD9xnS7K3XGg@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-5-git-send-email-me@tobin.cc> <CAGXu5jJQOduZ5evB=1w5NymUFbDNoeB4Y4u2a7zJ8k8vsAojRQ@mail.gmail.com>
 <CA+55aFxBrFsN0wm1_SyafNZ6GHxCLBvwmRaAzfKD9xnS7K3XGg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 10:28:13 -0700
Message-ID: <CA+55aFw-MCtMHb6mAoTXU8dJCRNfwzrV7tS=aQZXryfeB9TExg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default
 kptr_restrict to the maximum value
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 10:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I honestly doubt the value of kptr_restrict. Any *sane* policy
> pretty much has to be in the caller, and by thinking about what you
> print out. IOW, things like proc_pid_wchan().

Looking at /proc/kallsyms is actually a prime example of this.

IOW, the old "open /proc/kallsyms as a normal user, then make it stdin
for some suid-root program that can be fooled to output it probably
works on it.

So kptr_restrict ends up being entirely the wrong thing to do there.

The only value in kptr_restrict ends up being as a complete hack,
where you say "I trust nobody" and make %p almost entirely useless.

And as mentioned, that will just make people use %x instead, or
randomly sprinkle the new "I didn't really mean this" modifiers like
the already discussed pr_debug() case.

So even when kptr_restrict "works", it ends up just fighting itself.
And most of the time it just doesn't work.

                Linus
