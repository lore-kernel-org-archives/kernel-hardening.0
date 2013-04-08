Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 8 Apr 2013 14:13:36 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130408121336.GE7513@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <20130405144954.GC29290@pd.tnic>
 <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
 <20130405204306.GA14092@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405204306.GA14092@pd.tnic>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Borislav Petkov <bp@alien8.de>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Apr 05, 2013 at 01:19:39PM -0700, Julien Tinnes wrote:
> > I think it'd be perfectly ok for OOPS to print out the kernel base.
> 
> Yeah, ok, this still would need some massaging of the oops output per
> script, but it shouldn't be a big problem.

Doesn't kallsyms decoding make it all useful in most cases?

(I assume that this patch-set still keeps kallsyms working.)

Thanks,

	Ingo
