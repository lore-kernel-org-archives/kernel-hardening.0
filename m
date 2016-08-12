Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 19:45:06 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160812174506.GA3119@nazgul.tnic>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com>
 <20160812054913.GA24303@nazgul.tnic>
 <CAJZ5v0hC28BMqgurck0oiQGxf=XhYwseiVs+DeLdv9wKHFCa7w@mail.gmail.com>
 <CAJcbSZEAyS6Lp=Cuz=-4yL39yz=Z_FpVuY2NiYjM=fchFtpTEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJcbSZEAyS6Lp=Cuz=-4yL39yz=Z_FpVuY2NiYjM=fchFtpTEg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Linux PM <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jiri Kosina <jikos@kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2016 at 09:03:52AM -0700, Thomas Garnier wrote:
> Borislav, let me know once you tested it and I will send a v2 with
> acked/tested.

Just did 5 s2d runs, back-to-back, with Rafael's linux-next branch.
Looks good so far, no hickups. I'll watch it the coming days if there
are any changes.

Reported-and-tested-by: Borislav Petkov <bp@suse.de>

Btw, I'm running with:

CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0x0

Thanks guys for the fixes.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
--
