Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 May 2016 20:43:45 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160505204345.4f936cd3ad2207c705d49c6a@gmail.com>
In-Reply-To: <20160503232527.6e02867a5d4b8f28f6c0f854@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202138.d50937e812b30aaba4f38a92@gmail.com>
	<CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
	<20160503232527.6e02867a5d4b8f28f6c0f854@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 1/6] Shared library support
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 3 May 2016 23:25:27 +0200
Emese Revfy <re.emese@gmail.com> wrote:

> > Do you need to change both the top Makefile and Makefile.clean
> > for belt-and-braces cleaning?
> 
> It doesn't delete the *.so files without the hunk from the top Makefile. 
> The mrproper and distclean targets remove them with this patch:
> https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/f23b7eb247ccc9f1007e53313af343980dd52591
> But I think this isn't the best solution much like doing it from the top Makefile.

Do you think this patch will be good enough? In this case I can resend the patch set.

-- 
Emese
