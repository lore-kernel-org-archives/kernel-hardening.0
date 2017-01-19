Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1484789346-21012-1-git-send-email-labbott@redhat.com>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 19 Jan 2017 14:08:12 -0800
Message-ID: <CAGXu5j+KA_+OxBo_fFO+YoZDyNYTCttRh06868o5-DAz53D30Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 0/2] Better hardening names
To: Laura Abbott <labbott@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 5:29 PM, Laura Abbott <labbott@redhat.com> wrote:
> Hi,
>
> It's come up previously that CONFIG_DEBUG_SET_MODULE_RONX and
> CONFIG_DEBUG_RODATA are not accurate names, mostly they should not have the
> word 'debug' in them. This series attempts to change the names to something
> a bit more descriptive and indicative of what they are actually used for these
> days.
>
> I marked this RFC for
> - Bike shedding purposes.
> - A discussion of what defaults should be. The way I did the refactoring, both
>   options are default y. I'd appreciate comments if there is a better approach.
> - Approach to split this up into more sub patches to make review/merging easier?
>   Or maybe it's fine.
>
> Quickly tested on arm/arm64/x86.
>
> Thanks,
> Laura
>
> Laura Abbott (2):
>   security: Change name of CONFIG_DEBUG_RODATA
>   security: Change name of CONFIG_DEBUG_SET_MODULE_RONX

Some day I'll quit reading my email backwards. :) I see you've got
MODULE_RONX renamed too here, please ignore my comment about needing
it "too". :)

-Kees

-- 
Kees Cook
Nexus Security
