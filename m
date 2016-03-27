Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 27 Mar 2016 23:09:13 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160327230913.bbbd9951fddca197b9b13b23@gmail.com>
In-Reply-To: <CAK7LNATK-r09tJ5K8u8vRdRR0dXywAJ=LbbhaigZkfMm3UUPmA@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000427.c82f18670568e1e656fc9532@gmail.com>
	<CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
	<20160324010749.f7e547e1df12b4944c5fa490@gmail.com>
	<CAK7LNATK-r09tJ5K8u8vRdRR0dXywAJ=LbbhaigZkfMm3UUPmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 26 Mar 2016 11:39:32 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> > I tried to remove the gcc-plugins target but sadly in this case the plugins aren't complied.
> > I don't know if I understand how it should work. I pushed a commit:
> > https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/0b005b886bde6c4b9134d01f830d88d464911a65
> > Could you please help me with what I did wrong?
> >
> Sorry, I missed this problem.
> 
> GCC-plugins must be compiled before descending into ./Kbuild.
> 
> 
> Please apply the following on top of commit 0b005b88
> and check if it works.
> 
> diff --git a/Makefile b/Makefile
> index 1c7a379..bd643d3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1009,6 +1009,9 @@ archprepare: archheaders archscripts prepare1
> scripts_basic
>  prepare0: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>  prepare0: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  prepare0: archprepare FORCE
> +ifdef CONFIG_GCC_PLUGINS
> +       $(Q)$(MAKE) $(build)=scripts/gcc-plugins
> +endif
>         $(Q)$(MAKE) $(build)=.
> 
>  # All the preparing..
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 0ba652c..1d80897 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -45,7 +45,6 @@ subdir-y                     += mod
>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>  subdir-$(CONFIG_DTC)         += dtc
>  subdir-$(CONFIG_GDB_SCRIPTS) += gdb
> -subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
> 
>  # Let clean descend into subdirs
> -subdir-        += basic kconfig package
> +subdir-        += basic kconfig package gcc-plugins

Thanks for the patch. I tested it and there is a problem when I run a parallel make.
The plugins are compiled later than needed (e.g., scripts/mod/empty.o). There is a lot of important
code under scripts/mod which may need the plugins. If the plugins were compiled when the "scripts_basic"
target runs it would be good but unfortunately the config symbol CONFIG_GCC_PLUGINS doesn't seem to be defined yet.
Could you please help me solve this problem?

-- 
Emese
