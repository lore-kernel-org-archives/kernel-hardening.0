Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Jun 2016 05:58:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20160621125807.GA19065@infradead.org>
References: <20160620203910.a8b6b5b10d18f24661916e7b@gmail.com>
 <20160620204119.6299c961570a7a9ad6cbdd51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160620204119.6299c961570a7a9ad6cbdd51@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 2/4] Add the latent_entropy gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, tytso@mit.edu, akpm@linux-foundation.org, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2016 at 08:41:19PM +0200, Emese Revfy wrote:
> --- /dev/null
> +++ b/scripts/gcc-plugins/latent_entropy_plugin.c
> @@ -0,0 +1,639 @@
> +/*
> + * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
> + * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
> + * Licensed under the GPL v2
> + *
> + * Note: the choice of the license means that the compilation process is
> + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
> + *       but for the kernel it doesn't matter since it doesn't link against
> + *       any of the gcc libraries

I remember we used to have architectures that actually linked against
libgcc.  Isn't that the case anymore?
