Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1448401114-24650-1-git-send-email-keescook@chromium.org>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
Date: Wed, 25 Nov 2015 10:13:07 +0100
Message-ID: <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: kernel-hardening@lists.openwall.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 24 November 2015 at 22:38, Kees Cook <keescook@chromium.org> wrote:
> Many things are written to only during __init, and never changed
> again. These cannot be made "const" since the compiler will do the wrong
> thing (we do actually need to write to them). Instead, move these items
> into a memory region that will be made read-only during mark_rodata_ro()
> which happens after all kernel __init code has finished.
>
> This introduces __read_only as a way to mark such memory, and uses it on
> the x86 vDSO to kill an extant kernel exploitation method.

...just some random notes on the experience with kernels implementing
such a feature for quite a lot of locations, not just the vDSO.

While having that annotation makes perfect sense, not only from a
security perspective but also from a micro-optimization point of view
(much like the already existing __read_mostly annotation), it has its
drawbacks. Violating the "r/o after init" rule by writing to such
annotated variables from non-init code goes unnoticed as far as it
concerns the toolchain. Neither the compiler nor the linker will flag
that incorrect use. It'll just trap at runtime and that's bad.

I myself had some educating experience seeing my machine triple fault
when resuming from a S3 sleep. The root cause was a variable that was
annotated __read_only but that was (unnecessarily) modified during CPU
bring-up phase. Debugging that kind of problems is sort of a PITA, you
could imagine.

So, prior extending the usage of the __read_only annotation some
toolchain support is needed. Maybe a gcc plugin that'll warn/error on
code that writes to such a variable but is not __init itself. The
initify and checker plugins from the PaX patch might be worth to look
at for that purpose, as they're doing similar things already. Adding
such a check to sparse might be worth it, too.
A modpost check probably won't work as it's unable to tell if it's a
legitimate access (r/o) or a violation (/w access). So the gcc plugin
is the way to go, IMHO.


Regards,
Mathias
