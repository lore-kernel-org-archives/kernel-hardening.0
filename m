Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516CBA1D.8070306@zytor.com>
Date: Mon, 15 Apr 2013 19:40:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-7-git-send-email-keescook@chromium.org> <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com> <516A1D49.1050100@zytor.com> <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com> <516C702C.2030209@zytor.com> <CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com> <516C751B.4020505@zytor.com> <CAGXu5jJvGx=5YV3mw6DTO75HwO_Yn_vbTN2GkkZr-CiqJqw=_g@mail.gmail.com> <516CB7EE.8070702@zytor.com>
In-Reply-To: <516CB7EE.8070702@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Kees Cook <keescook@chromium.org>
Cc: Eric Northup <digitaleric@google.com>, Yinghai Lu <yinghai@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/15/2013 07:31 PM, H. Peter Anvin wrote:
> 
> I also am starting to think that this really would be done better being
> integrated with the decompressor code, since that code already ends up
> moving the code around... no reason to do this again.
> 

Another good reason to do this in the decompressor wrapper: it can be
written in C that way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
