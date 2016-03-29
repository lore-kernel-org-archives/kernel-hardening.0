Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	<CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
Date: Tue, 29 Mar 2016 17:55:40 -0500
Message-ID: <CA+55aFx_4a245DQ-9=rW4reJ_Qa-+sZ3QG840kyVmcG8ebdEBg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 5:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So you could do 4 32
>
>  - the random value
>  - the low 32 bits of the address of the cookie
>  - the low 32 bits of the return point stack and instruction pointer

Oops, editing mishap. That was supposed to be about the 128-bit md5
chunk, which uses 4 32-bit values, but then I edited things and didn't
get back to it.

                Linus
