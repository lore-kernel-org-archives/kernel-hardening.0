Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 3 Jun 2016 19:42:52 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160603194252.91064b8e682ad988283fc569@gmail.com>
In-Reply-To: <20160601124227.e922af8299168c09308d5e1b@linux-foundation.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
	<20160531013145.612696c12f2ef744af739803@gmail.com>
	<20160601124227.e922af8299168c09308d5e1b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc plugin
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 1 Jun 2016 12:42:27 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 31 May 2016 01:31:45 +0200 Emese Revfy <re.emese@gmail.com> wrote:
> 
> > This plugin mitigates the problem of the kernel having too little entropy during
> > and after boot for generating crypto keys.
> > 
> > It creates a local variable in every marked function. The value of this variable is
> > modified by randomly chosen operations (add, xor and rol) and
> > random values (gcc generates them at compile time and the stack pointer at runtime).
> > It depends on the control flow (e.g., loops, conditions).
> > 
> > Before the function returns the plugin writes this local variable
> > into the latent_entropy global variable. The value of this global variable is
> > added to the kernel entropy pool in do_one_initcall() and _do_fork().
> 
> I don't think I'm really understanding.  Won't this produce the same
> value on each and every boot?

No, because of interrupts and intentional data races.

-- 
Emese
