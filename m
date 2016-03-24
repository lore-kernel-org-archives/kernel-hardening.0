Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 24 Mar 2016 01:07:49 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160324010749.f7e547e1df12b4944c5fa490@gmail.com>
In-Reply-To: <CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000427.c82f18670568e1e656fc9532@gmail.com>
	<CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 11 Mar 2016 15:25:19 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> You sprinkle "gcc-plugins" target in the top Makefile, which I do not like.
> 
> Can you descend into scripts/gcc-plugins from scripts/Makefile?
> 
> 
>  subdir-$(CONFIG_MODVERSIONS) += genksyms
>  subdir-y                     += mod
>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>  subdir-$(CONFIG_DTC)         += dtc
>  subdir-$(CONFIG_GDB_SCRIPTS) += gdb
> +subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
> 
> 
> This is how other host tools do, I think.

Hi,

I tried to remove the gcc-plugins target but sadly in this case the plugins aren't complied.
I don't know if I understand how it should work. I pushed a commit:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/0b005b886bde6c4b9134d01f830d88d464911a65
Could you please help me with what I did wrong?

Thanks
-- 
Emese
