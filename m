Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160307000730.5f5b379d0e88b97fc0112c8e@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000730.5f5b379d0e88b97fc0112c8e@gmail.com>
Date: Mon, 7 Mar 2016 13:07:32 -0800
Message-ID: <CAGXu5jLEizJK=YBrErDZGbANwWe2AdnsRPLAQL=nvnuCC_Q8LQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 5/5] Add sancov plugin
To: Dmitry Vyukov <dvyukov@google.com>, Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 6, 2016 at 3:07 PM, Emese Revfy <re.emese@gmail.com> wrote:
> The sancov gcc plugin inserts a __sanitizer_cov_trace_pc() call
> at the start of basic blocks.
>
> This plugin is a helper plugin for the kcov feature. It supports
> all gcc versions with plugin support (from gcc-4.5 on).
> It is based on the gcc commit "Add fuzzing coverage support" by Dmitry Vyukov
> (https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296).

Very cool! Dmitry, is this something you could put to good use?

> [...]
> diff --git a/tools/gcc/sancov_plugin.c b/tools/gcc/sancov_plugin.c
> new file mode 100644
> index 0000000..5a9179b
> --- /dev/null
> +++ b/tools/gcc/sancov_plugin.c
> @@ -0,0 +1,133 @@
> +/*
> + * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
> + * Licensed under the GPL v2, or (at your option) v3
> + *
> + * Homepage:
> + * https://github.com/ephox-gcc-plugins/sancov
> + *
> + * This plugin inserts a __sanitizer_cov_trace_pc() call at the start of basic blocks.
> + * It supports all gcc versions with plugin support (from gcc-4.5 on).
> + * It is based on the commit "Add fuzzing coverage support" by Dmitry Vyukov <dvyukov@google.com>.
> + *
> + * You can read about it more here:
> + *  https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296
> + *  http://lwn.net/Articles/674854/
> + *  https://github.com/google/syzkaller
> + *  https://lwn.net/Articles/677764/
> + *
> + * Usage:
> + * make run

Is this accurate? Wouldn't it just be selected from CONFIGs during kernel build?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
