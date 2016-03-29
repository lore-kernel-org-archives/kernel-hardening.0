Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu> <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Mar 2016 16:05:07 -0700
Message-ID: <CALCETrWi_+oDLfq22sfa6jYdvvqfw+O7hu_2sRaO1k=irm0yDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Bauer <sbauer@eng.utah.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 3:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 29, 2016 at 2:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>>
>> These patches implement the necessary changes to generate a cookie
>> which will be placed above signal frame upon signal delivery to userland.
>> The cookie is generated using a per-process random value xor'd with
>> the address where the cookie will be stored on the stack.
>

> I realize that this would likely need to be a separate and non-default
> extra hardening mode, because there are *definitely* applications that
> take signals and then update the return address (maybe single-stepping
> over instructions etc). But for a *lot* of applications, signal return
> implies changing no signal state at all, and mixing in the returning
> IP and SP would seem to be a fundamentally stronger cookie.

Like selftests/x86? :)

If we wanted to increase confidence that this wouldn't break existing
applications, I've been thinking about adding an extensible bit mask
of backwards compatibility breaks that an and/or libc is okay with.
One of these would be "I don't use vsyscalls", in which case the
vsyscall page would be unmapped entirely.  Another could be
"sigcontext cookies are okay".  These could potentially be programmed
by syscall and/or ELF notes.

--Andy
