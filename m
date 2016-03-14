Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 14 Mar 2016 22:02:47 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160314220247.5d4ea9efe0024820599435d4@gmail.com>
In-Reply-To: <CAK7LNARmTT2ixjwXWBZJOF+E79NAsRP3fTcfM3Fk9hf1zvFNVA@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000531.d43ae7df74bfa5e9e9e29087@gmail.com>
	<CAK7LNARmTT2ixjwXWBZJOF+E79NAsRP3fTcfM3Fk9hf1zvFNVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 3/5] Add Cyclomatic complexity GCC plugin
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 11 Mar 2016 15:26:39 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> > diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> > index 7c85bf2..dd7b56d 100644
> > --- a/scripts/Makefile.gcc-plugins
> > +++ b/scripts/Makefile.gcc-plugins
> > @@ -5,7 +5,11 @@ else
> >  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
> >  endif
> >  ifneq ($(PLUGINCC),)
> > -export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
> > +ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
> > +GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so
> > +endif
> > +GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
> > +export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY
> 
> 
> Do you need to export "GCC_PLUGIN_CYC_COMPLEXITY"?
> I do not see any reference to it.

This is a demo plugin. I just want to demonstrate how to use this infrastructure but I can remove it.
In my project there would be other plugins which use the export.

> If we expect more and more plugins in the future,
> is it better to do like this?
> 
> gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)  += cyc_complexity_plugin.so
> gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)          += sancov_plugin.so
> gcc-plugin-$(CONFIG_GCC_PLUGIN_FOO)             += foo_plugin.so
> 
> 
> GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/tools/gcc/,
> $(gcc-plugin-y))

Yes, it is better, I will do it.

-- 
Emese
