Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 May 2016 12:56:59 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160518125659.a608972488e2c33f9ec3ed7b@gmail.com>
In-Reply-To: <573B2A75.9030603@suse.com>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
	<20160513015725.30223ee16a2a3860b4392b90@gmail.com>
	<573B2A75.9030603@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v8 2/4] GCC plugin infrastructure
To: Michal Marek <mmarek@suse.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 17 May 2016 16:28:05 +0200
Michal Marek <mmarek@suse.com> wrote:

> Dne 13.5.2016 v 01:57 Emese Revfy napsal(a):
> > --- /dev/null
> > +++ b/scripts/Makefile.gcc-plugins
> > @@ -0,0 +1,21 @@
> > +ifdef CONFIG_GCC_PLUGINS
> > +  __PLUGINCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
> > +  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
> > +
> > +  GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y))
> > +
> > +  ifeq ($(PLUGINCC),)
> > +    ifneq ($(GCC_PLUGINS_CFLAGS),)
> > +      ifeq ($(call cc-ifversion, -ge, 0405, y), y)
> > +        PLUGINCC := $(shell $(CO, NFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
> > +        $(error error, your gcc installation does not support plugins, perhaps the necessary headers are missing?)
> > +      else
> > +        $(error error, your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
> > +      endif
> > +    endif
> > +  endif
> > +
> > +  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> > +  GCC_PLUGIN := $(gcc-plugin-y)
> > +
> > +endif
> 
> Hi Emese,
> 
> sorry for the late feedback. A problem I ran into now is that if you
> have a compiler that is either too old or built with plugin support
> disabled, scripts/Makefile.gcc-plugins errors out immediately. This is
> going to be an issue with allmodconfig/allyesconfig test builds. A
> solution would either be to make the respective options depend on
> !COMPILE_TEST, or turn the errors into warnings and do nothing if the
> compiler lacks plugin support. We are handling CONFIG_CC_STACKPROTECTOR
> on x86 this way already.

Hi,

I'll change the errors to warnings in the next patch set.

-- 
Emese
