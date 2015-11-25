Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 25 Nov 2015 12:05:25 +0100
MIME-Version: 1.0
Message-ID: <565595F5.32536.DB9FE75@pageexec.freemail.hu>
In-reply-to: <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>, <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Nov 2015 at 10:13, Mathias Krause wrote:

> I myself had some educating experience seeing my machine triple fault
> when resuming from a S3 sleep. The root cause was a variable that was
> annotated __read_only but that was (unnecessarily) modified during CPU
> bring-up phase. Debugging that kind of problems is sort of a PITA, you
> could imagine.

actually the kernel could silently recover from this given how the
page fault handler could easily determine that the fault address fell
into the data..read_only section and just silently undo the read-only
property, log the event to dmesg and retry the faulting access.

> So, prior extending the usage of the __read_only annotation some
> toolchain support is needed. Maybe a gcc plugin that'll warn/error on
> code that writes to such a variable but is not __init itself.

this is exactly what i suggested earlier in the constify thread ;).
note that this will produce false positives because __init* annotations
are not propagated everywhere they could be.

> The initify and checker plugins from the PaX patch might be worth to
> look at for that purpose, as they're doing similar things already.

one of our plans for initify is to add the discovery and propagation
of _init* annotations as well, it'd not only fix the false positives
mentioned above but also help reduce the kernel size (code/data/rodata).
