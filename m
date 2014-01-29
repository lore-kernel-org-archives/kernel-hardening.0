Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1390996897.20153.123.camel@i7.infradead.org>
References: <1380833605-26313-1-git-send-email-keescook@chromium.org>
	<1380833605-26313-2-git-send-email-keescook@chromium.org>
	<1390996897.20153.123.camel@i7.infradead.org>
Date: Wed, 29 Jan 2014 08:57:40 -0800
Message-ID: <CAGXu5jKnabMPHF2iNph5QFue0ZADSXoCzoCJXPgh_QC7SUN8mw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86, boot: fix word-size assumptions in has_eflag()
 inline asm
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 29, 2014 at 4:01 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> Commit dd78b97367bd575918204cc89107c1479d3fc1a7 ("x86, boot: Move CPU
> flags out of cpucheck") introduced ambiguous inline asm in the
> has_eflag() function. We want the instruction to be 'pushfl', but we
> just say 'pushf' and hope the compiler does what we wanted.
>
> When building with 'clang -m16', it won't, because clang doesn't use
> the horrid '.code16gcc' hack that even 'gcc -m16' uses internally.
>
> Say what we mean and don't make the compiler make assumptions.
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Yes, excellent point. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
