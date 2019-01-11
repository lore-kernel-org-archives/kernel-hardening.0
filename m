MIME-Version: 1.0
References: <1547198328-26359-1-git-send-email-yamada.masahiro@socionext.com> <1547198328-26359-2-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1547198328-26359-2-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 11 Jan 2019 09:20:05 -0800
Message-ID: <CAGXu5jJCZ35qM6y8p+J=1Z58cGM-ZZTpbcke46uQmCNBpptRmg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kbuild: simplify GCC plugin build rules
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Michal Marek <michal.lkml@markovi.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 11, 2019 at 1:19 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> GCC-plugin is the only user of the shared library build rules in
> scripts/Makefile.host. Hence, those rules do not need to be treewide
> available.
>
> The build rules in scripts/Makefile.host are written in a too generic
> way. I guess the main reason is because commit 24403874316a ("Shared
> library support") revived the code ripped off by commit 62e2210798ed
> ("kbuild: drop shared library support from Makefile.host").
>
> Currently, every plugin is built from a single C file. So, all we need
> is a pattern rule to create %.so from %.c.

What'll it look like if we get a multi-file plugin in the future?
There are existing out-of-tree plugins that this change may make
porting more difficult...

-- 
Kees Cook
