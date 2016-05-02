Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 2 May 2016 19:56:17 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
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

> In the first place,
> I am wondering if we need to revive this documentation.
> What this commit is only interested in *.so generation,
> not host program support.

I agree that we don't need this documentation. I'll remove it.
  
> > @@ -124,5 +158,39 @@ quiet_cmd_host-cxxobjs     = HOSTCXX $@
> >  $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
> >         $(call if_changed_dep,host-cxxobjs)
> >
> > +# Compile .c file, create position independent .o file
> > +# host-cshobjs -> .o
> > +quiet_cmd_host-cshobjs = HOSTCC  -fPIC $@
> > +      cmd_host-cshobjs = $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
> > +$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
> > +       $(call if_changed_dep,host-cshobjs)
> > +
> > +# Compile .c file, create position independent .o file
> 
> 
> Please explain why c++ compiler should be used to compile .c files.
> 
> This is not clear, so worth commenting.

Where do you think that the C++ compiler is used above? I think HOSTCC can only be C compiler.

-- 
Emese
