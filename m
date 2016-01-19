Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1453226922-16831-9-git-send-email-keescook@chromium.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org> <1453226922-16831-9-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 19 Jan 2016 11:09:06 -0800
Message-ID: <CALCETrVBbJROcYPmhAnOsjM6WCrY4+fhxCC75G1xz1bYawBNpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 8/8] x86, vdso: mark vDSO read-only after init
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 10:08 AM, Kees Cook <keescook@chromium.org> wrote:
> The vDSO does not need to be writable after __init, so mark it as
> __ro_after_init. The result kills the exploit method of writing to the
> vDSO from kernel space resulting in userspace executing the modified code,
> as shown here to bypass SMEP restrictions: http://itszn.com/blog/?p=21
>
> The memory map (with added vDSO address reporting) shows the vDSO moving
> into read-only memory:

Acked-by: Andy Lutomirski <luto@kernel.org>
