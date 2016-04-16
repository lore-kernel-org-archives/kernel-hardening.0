Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 16 Apr 2016 10:42:28 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160416084228.GA30071@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-4-git-send-email-keescook@chromium.org>
 <20160415080715.GD30715@gmail.com>
 <CAGXu5jKXP0i28gbZ9Yu=fgrJ8G6kcs5oWem_1av2bezj72KK2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKXP0i28gbZ9Yu=fgrJ8G6kcs5oWem_1av2bezj72KK2Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 03/21] x86, KASLR: Drop
 CONFIG_RANDOMIZE_BASE_MAX_OFFSET
To: Kees Cook <keescook@chromium.org>
Cc: Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> > Also note the assertive tone: if this Kconfig feature is eanbled, we say that 
> > the kernel address _will_ be randomized, and we should make sure it is. (If 
> > for some weird reason randomization fails we should warn prominently during 
> > bootup.)
> 
> This will need some thought... is it better to fail to boot or to boot without 
> entropy? As-is, it's possible to randomly position the kernel base address at 
> exactly the location it was going to boot without KASLR too, yet this is still 
> considered random...

I think we should boot but print a prominent warning. On real systems it's not 
supposed to happen, right? So we want to know if it happens, but don't want to 
hassle the user with breaking the system by not booting.

> > Also, could we always mix the i8254 timer into this as well, not just when 
> > RDTSC is unavailable?
> 
> IIRC, hpa explicitly did not want to do this when he was making
> suggestions on this area. I would need to dig out the thread -- I
> can't find it now. I'd prefer to leave this as-is, since changing it
> would add yet another variable to the behavioral changes of this
> series.

Sure, can stay as-is for now.

Thanks,

	Ingo
