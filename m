Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20130405144954.GC29290@pd.tnic>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<20130405144954.GC29290@pd.tnic>
Date: Fri, 5 Apr 2013 13:19:39 -0700
Message-ID: <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
From: Julien Tinnes <jln@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 5, 2013 at 7:49 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Apr 04, 2013 at 01:07:35PM -0700, Kees Cook wrote:
>> This creates CONFIG_RANDOMIZE_BASE, so that the base offset of the kernel
>> can be randomized at boot.
>
> Right,
>
> if I'm reading this whole deal correctly, I have an issue with this
> in the sense that if this thing is enabled by default and people are
> running stripped kernels, an oops which is being reported is worth sh*t
> since all the addresses there are random and one simply can't map them
> back to which functions the callstack frames are pointing to. Which will
> majorly hinder debuggability, IMHO...

I think it'd be perfectly ok for OOPS to print out the kernel base.

Restricting access to these oopses becomes a different problem
(privilege separation). Some existing sandboxes (Chromium, vsftpd,
openssh..) are already defending against it.

Julien
