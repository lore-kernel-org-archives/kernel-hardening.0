Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 17:54:24 -0500
Message-ID: <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 2:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>
> These patches implement the necessary changes to generate a cookie
> which will be placed above signal frame upon signal delivery to userland.
> The cookie is generated using a per-process random value xor'd with
> the address where the cookie will be stored on the stack.

Side note: wouldn't it be better to make the cookie something that
doesn't make it trivial to figure out the random value in case you
already have access to a signal stack?

Maybe there could be a stronger variation of this that makes the
cookie be something like a single md5 round (not a full md5).
Something fast, and not necessarily secure, but something that needs
more than one single CPU instruction to figure out.

So you could do 4 32

 - the random value
 - the low 32 bits of the address of the cookie
 - the low 32 bits of the return point stack and instruction pointer

Yes, yes, md5 is not cryptographically secure, and making it a single
iteration rather than the full four makes it even less so, but if the
attacker can generate long arbitrary code, then the whole SROP is
pointless to begin with, no?

In contrast, with the plain xor, the SROP would be a trivial operation
if you can just force it to happen within the context of a signal, so
that you can just re-use the signal return stack as-is. But mixing in
the returning IP and SP would make it *much* harder to use the
sigreturn as an attack vector.

I realize that this would likely need to be a separate and non-default
extra hardening mode, because there are *definitely* applications that
take signals and then update the return address (maybe single-stepping
over instructions etc). But for a *lot* of applications, signal return
implies changing no signal state at all, and mixing in the returning
IP and SP would seem to be a fundamentally stronger cookie.

No?

                 Linus
