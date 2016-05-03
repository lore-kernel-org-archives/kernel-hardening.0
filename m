Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 May 2016 23:25:27 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160503232527.6e02867a5d4b8f28f6c0f854@gmail.com>
In-Reply-To: <CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202138.d50937e812b30aaba4f38a92@gmail.com>
	<CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 1/6] Shared library support
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2 May 2016 14:03:00 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

Hi,

> > diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
> > index 55c96cb..e4e88ab 100644
> > --- a/scripts/Makefile.clean
> > +++ b/scripts/Makefile.clean
> > @@ -38,7 +38,8 @@ subdir-ymn    := $(addprefix $(obj)/,$(subdir-ymn))
> >  __clean-files  := $(extra-y) $(extra-m) $(extra-)       \
> >                    $(always) $(targets) $(clean-files)   \
> >                    $(host-progs)                         \
> > -                  $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
> > +                  $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
> > +                  $(hostlibs-y) $(hostlibs-m) $(hostlibs-)
> 
> $(hostcxxlibs-y)$(hostcxxlibs-m) is missing here.
> 
> 
> BTW, are you planning to support hostlibs without .so extention in the future?
> 
> 
> You are changing the top Makefile to clean with "*.so" pattern rule.
> 
> Do you need to change both the top Makefile and Makefile.clean
> for belt-and-braces cleaning?

It doesn't delete the *.so files without the hunk from the top Makefile. 
The mrproper and distclean targets remove them with this patch:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/f23b7eb247ccc9f1007e53313af343980dd52591
But I think this isn't the best solution much like doing it from the top Makefile.

-- 
Emese
