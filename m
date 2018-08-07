Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 7 Aug 2018 12:03:09 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel
 addresses
Message-ID: <20180807100309.GB12200@gmail.com>
References: <20180807012257.20157-1-jannh@google.com>
 <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, dvyukov@google.com
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@amacapital.net> wrote:

> > On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
> > 
> > There have been multiple kernel vulnerabilities that permitted userspace to
> > pass completely unchecked pointers through to userspace accessors:
> > 
> > - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
> >  access_ok() checks")
> > - the sg/bsg read/write APIs
> > - the infiniband read/write APIs
> > 
> > These don't happen all that often, but when they do happen, it is hard to
> > test for them properly; and it is probably also hard to discover them with
> > fuzzing. Even when an unmapped kernel address is supplied to such buggy
> > code, it just returns -EFAULT instead of doing a proper BUG() or at least
> > WARN().
> > 
> > This patch attempts to make such misbehaving code a bit more visible by
> > WARN()ing in the pagefault handler code when a userspace accessor causes
> > #PF on a kernel address and the current context isn't whitelisted.
> 
> I like this a lot, and, in fact, I once wrote a patch to do something similar. It was before 
> the fancy extable code, though, so it was a mess.  Here are some thoughts:

Agreed - please move this series beyond the RFC phase.

> - It should be three patches. One patch to add the _UA annotations, one to improve the info 
>   passes to the handlers, and one to change behavior.
>
> - You should pass the vector, the error code, and the address to the handler.
> 
> - The uaccess handler should IMO WARN if the vector is anything other than #PF (which mainly 
> means warning if it’s #GP). I think it should pr_emerg() and return false if the vector is 
> #PF and the address is too high.
> 
> - Arguably most non-uaccess fixups should at least warn for anything other than #GP and #UD.

Ack.

Thanks,

	Ingo
