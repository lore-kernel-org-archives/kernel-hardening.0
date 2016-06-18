Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Jun 2016 12:37:08 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160618103708.GB3841@pd.tnic>
References: <cover.1466192946.git.luto@kernel.org>
 <3336bb02792d56c49d18e2f7a435fd194a4a22e4.1466192946.git.luto@kernel.org>
 <20160617203045.GB3842@pd.tnic>
 <CALCETrW-i8p=w5PTW817kAmfybHUntYkcAjc6sUsFJGcDGdnMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrW-i8p=w5PTW817kAmfybHUntYkcAjc6sUsFJGcDGdnMA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 03/13] x86/cpa: Warn if kernel_unmap_pages_in_pgd is
 used inappropriately
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 18, 2016 at 03:29:01AM -0700, Andy Lutomirski wrote:
> I'll do one better: the only function that calls this function is
> unused.  I'll just delete it.

Fair enough - Matt is on CC.

Btw, normally I'm almost never talking to you at that time of the day,
what's up? Can't sleep?

:-))

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
