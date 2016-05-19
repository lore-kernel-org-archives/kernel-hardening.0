Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 19 May 2016 10:24:13 +0200
MIME-Version: 1.0
Message-ID: <573D782D.10392.75A275C@pageexec.freemail.hu>
In-reply-to: <1463638931.10451.10.camel@ellerman.id.au>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>, <20160518123327.9018f73af78a47b4456b2027@gmail.com>, <1463638931.10451.10.camel@ellerman.id.au>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linux-kbuild@vger.kernel.org, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 19 May 2016 at 16:22, Michael Ellerman wrote:

> On Wed, 2016-05-18 at 12:33 +0200, Emese Revfy wrote:
> > Did you test the plugins with all gcc versions (4.5-6)?
> 
> What's the concern about gcc versions? Just not breaking the build on old
> compilers?

the earlier plugin capable gcc versions used to install gcc headers in a somewhat
ad-hoc manner resulting in compile time breakage for plugins and since some of
those potentially missing headers are target specific, each target arch should
be verified before enabling plugin support on them. things have much improved with
gcc 5 (see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61176) though there's still
an occasional missing header but with wider use of plugins they will hopefully be
discovered earlier now. perhaps linux-arch should be cc'ed on the plugin infrastructure
so that arch maintainers are aware of this?

> I'm pretty sure powerpc big endian still builds with gcc 4.4.
> 
> However if Andrew's only tested on little endian, then that select should be
> guarded with an "if CPU_LITTLE_ENDIAN". And to build LE you need gcc >= 4.9.

i guess that's part of the target tuple so in general arch maintainers should test
the target tuples used on their arch with all the supported gcc versions (speaking
of CC, not HOSTCC/HOSTCXX).

cheers,
 PaX Team
