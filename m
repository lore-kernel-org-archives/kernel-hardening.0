MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <4e668302-8754-3f4e-3372-d0d7ba30cfa3@linux.intel.com>
References: <1523024546-6150-1-git-send-email-alex.popov@linux.com>
 <1523024546-6150-3-git-send-email-alex.popov@linux.com> <4e668302-8754-3f4e-3372-d0d7ba30cfa3@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Apr 2018 16:48:41 -0700
Message-ID: <CAGXu5jJ_0e63QSv0YZsQoT_=zN8U-83nwxrQ10h=QjszbHK-aQ@mail.gmail.com>
Subject: Re: [PATCH v11 2/6] x86/entry: Add STACKLEAK erasing the kernel stack
 at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 23, 2018 at 9:23 PM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> Hi Alexander,
>
> You can add:
>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
>
> for this patch if you like.  I haven't taken a super close look at the
> rest, but this is certainly minimally invasive from my point of view for
> the entry code.  Thanks, again for reworking it.

Thanks Dave!

Given this improvement and your review, I'm going to start carrying
this for linux-next. Linus, if you're still opposed to this even after
the changes here in v11, please let us know. I'd rather hash things
out now instead of during a NAK in the 4.18 merge window. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
