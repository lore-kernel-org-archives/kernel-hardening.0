Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 5 Apr 2013 22:43:06 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20130405204306.GA14092@pd.tnic>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <20130405144954.GC29290@pd.tnic>
 <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Julien Tinnes <jln@google.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 05, 2013 at 01:19:39PM -0700, Julien Tinnes wrote:
> I think it'd be perfectly ok for OOPS to print out the kernel base.

Yeah, ok, this still would need some massaging of the oops output per
script, but it shouldn't be a big problem.

Also, you probably need to make clear in the oops itself that the
addresses have been randomized. Or, is the mere presence of kernel base
going to imply that?

> Restricting access to these oopses becomes a different problem
> (privilege separation). Some existing sandboxes (Chromium, vsftpd,
> openssh..) are already defending against it.

Ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
