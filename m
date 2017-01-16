Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 16 Jan 2017 20:22:24 +0100
MIME-Version: 1.0
Message-ID: <587D1D70.26193.89AFE10@pageexec.freemail.hu>
In-reply-to: <20170116115435.GB5908@leverpostej>
References: <20170113220256.GA57663@beast>, <20170116115435.GB5908@leverpostej>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, dave.martin@arm.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 16 Jan 2017 at 11:54, Mark Rutland wrote:

> > + * Copyright 2013-2017 by PaX Team <pageexec@freemail.hu>
> > + * Licensed under the GPL v2
> > + *
> > + * Note: the choice of the license means that the compilation process is
> > + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
> > + *       but for the kernel it doesn't matter since it doesn't link against
> > + *       any of the gcc libraries
> 
> It's my understanding that some architectures do link against libgcc, so we
> might want some kind of guard to avoid mishaps. e.g.
> ARCH_CAN_USE_NON_GPLV3_GCC_PLUGINS.

AFAIK, plugins aren't enabled on any such archs yet and if/when they get
enabled, the better approach would be to simply reimplement those helper
routines in the kernel itself like some archs already do.

> > +	/* build the initializer expression */
> > +	initializer = build_constructor(TREE_TYPE(var), NULL);
> > +
> > +	/* build the initializer stmt */
> > +	init_stmt = gimple_build_assign(var, initializer);
> > +	gsi = gsi_after_labels(single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
> > +	gsi_insert_before(&gsi, init_stmt, GSI_NEW_STMT);
> > +	update_stmt(init_stmt);
> 
> I assume that this is only guaranteed to initialise fields in a struct,
> and not padding, is that correct? I ask due to the issue described in:
> 
> https://lwn.net/Articles/417989/

the 'issue' is that before C11 the standard didn't make it clear that in
case of a partial initializer list the compiler has to initialize not only
the remaining fields but also padding as well.

as for what the above code does, it fixes this as well since gcc doesn't
emit the constructor itself which will then match the pattern.
