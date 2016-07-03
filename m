Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 3 Jul 2016 20:42:13 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160703184213.GB1781@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <37ac7589ff0ea147e8a21cda5eb84d3af1f6cd60.1466974736.git.luto@kernel.org>
 <20160702172441.GA22748@pd.tnic>
 <20160702183451.e2nlfkfxlsuicbqd@treble>
 <CALCETrVowqk90fmsg9eJG7Fvk0EMVFS0azCbJ89dioRtuXZOKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVowqk90fmsg9eJG7Fvk0EMVFS0azCbJ89dioRtuXZOKQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 10/29] x86/die: Don't try to recover from an OOPS on a
 non-default stack
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 03, 2016 at 07:25:05AM -0700, Andy Lutomirski wrote:
> Given that the very next patch deletes this code, I vote for leaving
> it alone.  Or I could fold the patches together.

Ah, true. Yes, please fold them together.

-- 
Regards/Gruss,
Boris.

ECO tip #101: Trim your mails when you reply.
