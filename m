Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 27 Apr 2013 00:19:15 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20130426221915.GB26059@pd.tnic>
References: <1367003005-5560-7-git-send-email-keescook@chromium.org>
 <20130426221301.GA26059@pd.tnic>
 <517AFC6E.4020800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <517AFC6E.4020800@zytor.com>
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: report kernel offset on panic
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2013 at 03:15:10PM -0700, H. Peter Anvin wrote:
> That really makes it harder to figure out what the heck the register
> content may mean...

So we need a goddam script to massage oopses now, if kaslr is enabled.

:-(

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
