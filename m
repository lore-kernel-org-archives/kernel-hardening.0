Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 14 Mar 2016 22:25:44 +0100
MIME-Version: 1.0
Message-ID: <56E72C58.28997.25D483C7@pageexec.freemail.hu>
In-reply-to: <CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>, <20160307000427.c82f18670568e1e656fc9532@gmail.com>, <CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11 Mar 2016 at 15:25, Masahiro Yamada wrote:

> > diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
> > new file mode 100644
> > index 0000000..eaa4fce
> > --- /dev/null
> > +++ b/scripts/gcc-plugin.sh
> > @@ -0,0 +1,51 @@
> > +#!/bin/sh
> > +srctree=$(dirname "$0")
> > +gccplugins_dir=$($3 -print-file-name=plugin)
> > +plugincc=$($1 -E -x c++ - -o /dev/null -I"${srctree}"/../tools/gcc -I"${gccplugins_dir}"/include 2>&1 <<EOF
> > +#include "gcc-common.h"
> 
> 
> Maybe <gcc-common.h> because it is not located at the same directory?

[snip]
> > +#include "emit-rtl.h"
> > +#include "debug.h"
> > +#include "target.h"
> > +#include "langhooks.h"
> > +#include "cfgloop.h"
> > +#include "cgraph.h"
> > +#include "opts.h"
> 
> All of these are included by "...", not <...>.
> 
> 
> As mentioned above, I want you to use "..." style
> when you need to use relative path from the source.
> 
> I do not see most of them in tools/gcc/.

no, that'd be incorrect for several reasons. first, the rule to use <...> vs. "..."
include directives is not about the header being in the same directory but whether
the header is a system header or one provided by the given program. roughly speaking,
system headers are those that are available through the compiler's default include
paths (gcc's own headers, those of glibc and other libraries under /usr/include, etc).
gcc plugin headers are *not* available by default, one has to query the compiler about
their path (see -print-file-name=plugin above) and explicitly add it to the compiler's
include search path.

second, regardless of whether plugin headers are available by default or not, we
still couldn't use them during cross-compilation as the plugin headers we want are
those of the target compiler (that will load the plugin eventually), not that of
the host compiler (which merely compiles the plugin and in theory doesn't even have
to be gcc or a plugin capable gcc).

for these reasons the correct include directive is "..." and not <...>. if it helps
to understand the situation better, consider that gcc plugins are to gcc as kernel
modules are to vmlinux and all kernel headers are included via "..." as well, regardless
of whether they're in the same directory or not.

cheers,
 PaX Team
