Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 11 Jan 2017 01:24:59 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com>
In-Reply-To: <CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
	<CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
	<20161219121046.646e5ef425178fce8c2cb555@gmail.com>
	<CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 3 Jan 2017 16:23:03 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Dec 19, 2016 at 3:10 AM, Emese Revfy <re.emese@gmail.com> wrote:
> > On Fri, 16 Dec 2016 14:19:10 -0800
> > Kees Cook <keescook@chromium.org> wrote:
> >
> >> FWIW, it still seems to me that these aren't false positives:
> >>
> >> WARNING: vmlinux.o(.text.unlikely+0x1b1): Section mismatch in
> >> reference from the function uncore_pci_exit.part.22() to the function
> >> .init.text:uncore_free_pcibus_map()
> >> The function uncore_pci_exit.part.22() references
> >> the function __init uncore_free_pcibus_map().
> >> This is often because uncore_pci_exit.part.22 lacks a __init
> >> annotation or the annotation of uncore_free_pcibus_map is wrong.

Thanks for the report, you can find the fix here:
https://github.com/ephox-gcc-plugins/initify/commit/5d93a54badd9751b79ef67ce8a8b4081fea37547

-- 
Emese
