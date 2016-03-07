Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 22:29:33 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160307222933.9a82c1c6247093b7facd180e@gmail.com>
In-Reply-To: <CAGXu5jLEizJK=YBrErDZGbANwWe2AdnsRPLAQL=nvnuCC_Q8LQ@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000730.5f5b379d0e88b97fc0112c8e@gmail.com>
	<CAGXu5jLEizJK=YBrErDZGbANwWe2AdnsRPLAQL=nvnuCC_Q8LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 5/5] Add sancov plugin
To: Kees Cook <keescook@chromium.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 7 Mar 2016 13:07:32 -0800
Kees Cook <keescook@chromium.org> wrote:

> > diff --git a/tools/gcc/sancov_plugin.c b/tools/gcc/sancov_plugin.c
> > new file mode 100644
> > index 0000000..5a9179b
> > --- /dev/null
> > +++ b/tools/gcc/sancov_plugin.c
> > @@ -0,0 +1,133 @@
> > +/*
> > + * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
> > + * Licensed under the GPL v2, or (at your option) v3
> > + *
> > + * Homepage:
> > + * https://github.com/ephox-gcc-plugins/sancov
> > + *
> > + * This plugin inserts a __sanitizer_cov_trace_pc() call at the start of basic blocks.
> > + * It supports all gcc versions with plugin support (from gcc-4.5 on).
> > + * It is based on the commit "Add fuzzing coverage support" by Dmitry Vyukov <dvyukov@google.com>.
> > + *
> > + * You can read about it more here:
> > + *  https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296
> > + *  http://lwn.net/Articles/674854/
> > + *  https://github.com/google/syzkaller
> > + *  https://lwn.net/Articles/677764/
> > + *
> > + * Usage:
> > + * make run
> 
> Is this accurate? Wouldn't it just be selected from CONFIGs during kernel build?

This is just a usage example when someone clones the plugin from github. Every plugin written by me contains this. :)

For now it can be enabled from menuconfig for testing because I'm waiting for the reactions.
Later I think the best way would be when kcov is enabled that it also enables the plugin automatically
if the target gcc version doesn't support the -fsanitize-coverage=trace-pc option but it supports plugins.

-- 
Emese
