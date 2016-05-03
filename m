Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 May 2016 23:29:32 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160503232932.706dd3bb081df5d04a390de9@gmail.com>
In-Reply-To: <CAK7LNATQY7AWjmEEjDFgpLPkO_oQgkNKutgGb17v7=R8RPb5zA@mail.gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202138.d50937e812b30aaba4f38a92@gmail.com>
	<CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
	<20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
	<CAK7LNATQY7AWjmEEjDFgpLPkO_oQgkNKutgGb17v7=R8RPb5zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 1/6] Shared library support
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 3 May 2016 11:00:56 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

Hi,

> # Compile .c file, create position independent .o file
> # host-cxxshobjs -> .o
> quiet_cmd_host-cxxshobjs = HOSTCXX -fPIC $@
>       cmd_host-cxxshobjs = $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
>                            $(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
>                            $(call if_changed_dep,host-cxxshobjs)
> 
> 
> 
> 
> We generally use HOSTCC to compile *.c files,
> and HOSTCXX to compile *.cc files.
> 
> 
> But, here, you mention to use HOSTCXX to compile .c files
> such as cyc_complexity_plugin.c, sancov_plugin.c, etc.
> 
> This is not straight-forward.  It is worthwhile to comment the reason.

I wrote a comment about it here:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/74f6343a7f13c071e00c417332051e25f15009ea

-- 
Emese
