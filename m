Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2016 12:10:46 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20161219121046.646e5ef425178fce8c2cb555@gmail.com>
In-Reply-To: <CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
	<CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 16 Dec 2016 14:19:10 -0800
Kees Cook <keescook@chromium.org> wrote:
 
> FWIW, it still seems to me that these aren't false positives:
> 
> WARNING: vmlinux.o(.text.unlikely+0x1b1): Section mismatch in
> reference from the function uncore_pci_exit.part.22() to the function
> .init.text:uncore_free_pcibus_map()
> The function uncore_pci_exit.part.22() references
> the function __init uncore_free_pcibus_map().
> This is often because uncore_pci_exit.part.22 lacks a __init
> annotation or the annotation of uncore_free_pcibus_map is wrong.

Hi,

I can't reproduce this section mismatch. Could you please send me your .config?
Which gcc version did you use?
I used this tree: git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git initify-v4

Thanks
-- 
Emese
