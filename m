MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJQOduZ5evB=1w5NymUFbDNoeB4Y4u2a7zJ8k8vsAojRQ@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-5-git-send-email-me@tobin.cc> <CAGXu5jJQOduZ5evB=1w5NymUFbDNoeB4Y4u2a7zJ8k8vsAojRQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 10:08:02 -0700
Message-ID: <CA+55aFxBrFsN0wm1_SyafNZ6GHxCLBvwmRaAzfKD9xnS7K3XGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default
 kptr_restrict to the maximum value
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 9:42 AM, Kees Cook <keescook@chromium.org> wrote:
>
> I'd argue that a default of "1" would be a sensible starting place,
> but that can be a separate patch, IMO.

I agree that '1' is a much saner default for _some_ uses, in that it
still gives root access to /proc file data etc.

However, the sad fact is that kptr_restrict just has bad semantics for
that case too, in that you do want to give root access to /proc files,
but the whole "is the current thread root" is a horrible horrible
test.

Partly it's horrible for the reasons mentioned in the source code (ie
the whole IRQ context thing etc), but that's actually the smallest
reason it's not great: the more fundamental issue is that even for
/proc files, it should use the cred for the file opener, not the
current user.

And for anything *but* /proc files, it's almost always the wrong thing
(ie random printk's aren't generally really associated with any user).

It might almost by mistake do the right thing (ie some kernel printk
that can be triggered by a normal user doing something odd), so it's
not like it always does the wrong thing, but it really is almost
entirely random.

So I seriously dislike kptr_restrict. The whole thing is mis-designed
for very very fundamental reasons.

And no, I also refuse to believe that the fix is "just make it have a
value of 4, and just hide all pointers". Because that will just mean
that people won't be using '%p' at all for debug messages etc, they'll
just use %x or whatever.

So I honestly doubt the value of kptr_restrict. Any *sane* policy
pretty much has to be in the caller, and by thinking about what you
print out. IOW, things like proc_pid_wchan().

                    Linus
