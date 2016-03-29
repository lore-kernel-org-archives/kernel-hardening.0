Reply-To: kernel-hardening@lists.openwall.com
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56FB0B88.2020306@eng.utah.edu>
Date: Tue, 29 Mar 2016 17:11:04 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>



On 03/29/2016 04:54 PM, Linus Torvalds wrote:
> On Tue, Mar 29, 2016 at 2:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>>
>> These patches implement the necessary changes to generate a cookie
>> which will be placed above signal frame upon signal delivery to userland.
>> The cookie is generated using a per-process random value xor'd with
>> the address where the cookie will be stored on the stack.
> 
> Side note: wouldn't it be better to make the cookie something that
> doesn't make it trivial to figure out the random value in case you
> already have access to a signal stack?
> 
> Maybe there could be a stronger variation of this that makes the
> cookie be something like a single md5 round (not a full md5).
> Something fast, and not necessarily secure, but something that needs
> more than one single CPU instruction to figure out.
> 
> So you could do 4 32
> 
>  - the random value
>  - the low 32 bits of the address of the cookie
>  - the low 32 bits of the return point stack and instruction pointer
> 
> Yes, yes, md5 is not cryptographically secure, and making it a single
> iteration rather than the full four makes it even less so, but if the
> attacker can generate long arbitrary code, then the whole SROP is
> pointless to begin with, no?
> 

Yeah I had toyed with using hashes, I used hash_64 not md5 which is like 14
extra instructions or something. Anyway Daniel Micay pointed out we could use SipHash
https://131002.net/siphash/, but there's no siphash for me to use in the kernel
and I'm the *last* person on earth to start porting/implementing 'crypto' algos.

Anyway, we all sort of agreed that if you have enough arbitrary execution already
to cause a signal, leak the cookie, do some xor magic to get the per-process 
secret then you probably don't really need to SROP in your exploit. Although
you did mention an interesting attack which is force a signal then muck with
an existing legitimate frame, which I would like to protect against now.

> In contrast, with the plain xor, the SROP would be a trivial operation
> if you can just force it to happen within the context of a signal, so
> that you can just re-use the signal return stack as-is. But mixing in
> the returning IP and SP would make it *much* harder to use the
> sigreturn as an attack vector.
> 
> I realize that this would likely need to be a separate and non-default
> extra hardening mode, because there are *definitely* applications that
> take signals and then update the return address (maybe single-stepping
> over instructions etc). But for a *lot* of applications, signal return
> implies changing no signal state at all, and mixing in the returning
> IP and SP would seem to be a fundamentally stronger cookie.
> 
> No?

It's not hard to implement So I can try it. When you say an extra hardening
mode do you mean hide it behind a sysctl or some sort of compile time CONFIG?
