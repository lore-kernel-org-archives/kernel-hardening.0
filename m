Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 14 Mar 2016 21:52:17 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160314215217.7fa20e0c85bfda75dc11b70c@gmail.com>
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

> Maybe scripts/gcc-plugins/ is better than tools/gcc ?
> 
> In the directory "scripts/", we have several tools used during
> building the kernel image.
> We have some optional programs in the directory "tools/", which are not used
> for building the kernel image itself.
> 
> Please correct me if I am wrong.

I think scripts isn't the right place because there are tools there which don't get used
during the building of vmlinux (e.g., coccinelle, checkpatch). 
The scripts name also doesn't describe gcc plugins well. Plugins take part in the image building process
in a different way than these tools and scripts do.
Since there doesn't seen to be a good place for compiler plugins, maybe we should create a new toplevel directory
called "build". Compiler plugins and other existing build tools could live there. What do you think?

> > +ccflags-y := $(GCC_PLUGINS_CFLAGS)
> > +asflags-y := $(GCC_PLUGINS_AFLAGS)
> > +
> >  obj-y                          := main.o version.o mounts.o
> >  ifneq ($(CONFIG_BLK_DEV_INITRD),y)
> >  obj-y                          += noinitramfs.o
> > diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> > new file mode 100644
> > index 0000000..7c85bf2
> > --- /dev/null
> > +++ b/scripts/Makefile.gcc-plugins
> > @@ -0,0 +1,28 @@
> > +ifdef CONFIG_GCC_PLUGINS
> > +ifeq ($(call cc-ifversion, -ge, 0408, y), y)
> > +PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCXX)" "$(HOSTCXX)" "$(CC)")
> > +else
> > +PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
> > +endif
> 
> The difference is only the first argument.
> 
> Can you make it as follows?
> 
> __HOSTCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
> 
> PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh
> "$(__HOSTCC)" "$(HOSTCXX)" "$(CC)")
> 
> 
> I did not come up with a good name for __HOSTCC.
> Feel free to replace it with a better one.

Sure, I will do it.

-- 
Emese
